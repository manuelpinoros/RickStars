import XCTest
@testable import NetworkKit

final class NetworkKitTests: XCTestCase {
    struct Dummy: Decodable, Equatable {
        let name: String
    }

    private var session: URLSession!
    private var client: URLSessionClient!

    override func setUp() {
        super.setUp()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [StubURLProtocol.self]
        session = URLSession(configuration: config)
        client = URLSessionClient(session: session)
    }

    override func tearDown() {
        Task {
            await StubURLProtocol.requestHandler.set(nil)
        }
        session = nil
        client = nil
        super.tearDown()
    }

    func testCharacterEndpointURLRequest() {
        let base = URL(string: "https://rickandmortyapi.com/api")!
        let endpoint = Endpoint(baseURL: base, path: "character", query: [
            URLQueryItem(name: "page", value: "2"),
            URLQueryItem(name: "name", value: "Rick")
        ])
        let req = endpoint.urlRequest
        XCTAssertEqual(req.url?.absoluteString, "https://rickandmortyapi.com/api/character?page=2&name=Rick")
        XCTAssertEqual(req.httpMethod, "GET")
    }

    func testMultipleCharactersEndpointURLRequest() {
        let base = URL(string: "https://rickandmortyapi.com/api")!
        let endpoint = Endpoint(baseURL: base, path: "character/1,2,3")
        let req = endpoint.urlRequest
        XCTAssertEqual(req.url?.absoluteString, "https://rickandmortyapi.com/api/character/1,2,3")
        XCTAssertEqual(req.httpMethod, "GET")
    }

    func testSuccessfulResponseDecodes() async throws {
        let expected = Dummy(name: "Rick")
        await StubURLProtocol.requestHandler.set { request in
            let response = HTTPURLResponse(
                url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = "{\"name\":\"Rick\"}".data(using: .utf8)!
            return (response, data)
        }

        let endpoint = Endpoint(baseURL: URL(string: "https://rickandmortyapi.com/api")!, path: "character")
        let value: Dummy = try await client.request(endpoint)
        XCTAssertEqual(value, expected)
    }

    func testInvalidResponseThrowsInvalidResponse() async {
        await StubURLProtocol.requestHandler.set { request in
            throw NSError(domain: "Test", code: 123, userInfo: nil)
        }
        do {
            let _: Dummy = try await client.request(
                Endpoint(baseURL: URL(string: "https://rickandmortyapi.com/api")!, path: "character")
            )
            XCTFail("Expected unknown error")
        } catch let error as NetworkError {
            switch error {
            case .unknown:
                break
            default:
                XCTFail("Expected unknown error, got \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testBadStatusCodeThrows() async {
        await StubURLProtocol.requestHandler.set { request in
            let response = HTTPURLResponse(
                url: request.url!, statusCode: 404, httpVersion: nil, headerFields: nil)!
            return (response, Data())
        }
        do {
            let _: Dummy = try await client.request(
                Endpoint(baseURL: URL(string: "https://rickandmortyapi.com/api")!, path: "character")
            )
            XCTFail("Expected badStatusCode error")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .badStatusCode(404))
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testDecodingErrorThrows() async {
        await StubURLProtocol.requestHandler.set { request in
            let response = HTTPURLResponse(
                url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = "not JSON".data(using: .utf8)!
            return (response, data)
        }
        do {
            let _: Dummy = try await client.request(
                Endpoint(baseURL: URL(string: "https://rickandmortyapi.com/api")!, path: "character")
            )
            XCTFail("Expected decodingError")
        } catch let error as NetworkError {
            switch error {
            case .decodingError:
                break
            default:
                XCTFail("Expected decodingError, got \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testURLErrorMapping() async {
        await StubURLProtocol.requestHandler.set { _ in
            throw URLError(.notConnectedToInternet)
        }
        do {
            let _: Dummy = try await client.request(
                Endpoint(baseURL: URL(string: "https://rickandmortyapi.com/api")!, path: "character")
            )
            XCTFail("Expected urlError")
        } catch let error as NetworkError {
            switch error {
            case .urlError(let urlErr):
                XCTAssertEqual(urlErr.code, .notConnectedToInternet)
            default:
                XCTFail("Expected urlError, got \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}

// MARK: - URLProtocol Stub
final class StubURLProtocol: URLProtocol {
    fileprivate static let requestHandler = Actor<((URLRequest) throws -> (HTTPURLResponse, Data))?>(nil)

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        Task {
            guard let handler = await StubURLProtocol.requestHandler.current else {
                fatalError("No handler set")
            }
            do {
                let (response, data) = try handler(request)
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                client?.urlProtocol(self, didLoad: data)
                client?.urlProtocolDidFinishLoading(self)
            } catch {
                client?.urlProtocol(self, didFailWithError: error)
            }
        }
    }

    override func stopLoading() {}
}

// Helper actor for thread-safe state
private actor Actor<T> {
    private var value: T
    
    init(_ value: T) {
        self.value = value
    }
    
    func set(_ newValue: T) {
        value = newValue
    }
    
    var current: T {
        value
    }
}
