import XCTest
@testable import RickMortyData
@testable import NetworkKit
@testable import RickMortyDomain

final class DefaultCharacterRepositoryTests: XCTestCase {
    private var sut: DefaultCharacterRepository!
    private var mockClient: MockNetworkClient!
    private var mockErrorMapper: MockErrorMapper!
    
    override func setUp() {
        super.setUp()
        mockClient = MockNetworkClient()
        mockErrorMapper = MockErrorMapper()
        sut = DefaultCharacterRepository(client: mockClient, errorMapper: mockErrorMapper)
    }
    
    override func tearDown() {
        sut = nil
        mockClient = nil
        mockErrorMapper = nil
        super.tearDown()
    }
    
    func testCharactersWhenSuccessfulReturnsMappedCharacters() async throws {
        // Given
        let expectedResponse = CharacterPageResponse(
            info: PageInfoResponse(next: "next-page"),
            results: [
                CharacterResponse(
                    id: 1,
                    name: "Rick",
                    status: "Alive",
                    species: "Human",
                    type: "",
                    origin: OriginResponse(name: "Earth", url: "url"),
                    location: LocationResponse(name: "Earth", url: "url"),
                    episode: ["episode1"],
                    image: URL(fileURLWithPath: "https://example.com")
                )
            ]
        )
        mockClient.mockResponse = expectedResponse
        
        // When
        let result = try await sut.characters(page: 1)
        
        // Then
        XCTAssertEqual(result.info.next, "next-page")
        XCTAssertEqual(result.results.count, 1)
        XCTAssertEqual(result.results[0].id, 1)
        XCTAssertEqual(result.results[0].name, "Rick")
    }
    
    func testCharactersWhenNetworkErrorThrowsMappedError() async {
        // Given
        let networkError = NetworkError.invalidResponse
        mockClient.mockError = networkError
        mockErrorMapper.mappedError = DomainError.resourceNotFound
        
        // When/Then
        do {
            _ = try await sut.characters(page: 1)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? DomainError, .resourceNotFound)
        }
    }
    
    func testCharactersWithNameWhenSuccessfulReturnsFilteredCharacters() async throws {
        // Given
        let expectedResponse = CharacterPageResponse(
            info: PageInfoResponse(next: nil),
            results: [
                CharacterResponse(
                    id: 1,
                    name: "Rick",
                    status: "Alive",
                    species: "Human",
                    type: "",
                    origin: OriginResponse(name: "Earth", url: "url"),
                    location: LocationResponse(name: "Earth", url: "url"),
                    episode: ["episode1"],
                    image: URL(fileURLWithPath: "https://example.com")
                )
            ]
        )
        mockClient.mockResponse = expectedResponse
        
        // When
        let result = try await sut.characters(page: 1, name: "Rick")
        
        // Then
        XCTAssertEqual(result.results.count, 1)
        XCTAssertEqual(result.results[0].name, "Rick")
    }
}

// MARK: - Mocks
private class MockNetworkClient: NetworkClient {
    var mockResponse: Any?
    var mockError: Error?
    
    func request<T>(_ endpoint: Endpoint) async throws -> T where T : Decodable {
        if let error = mockError {
            throw error
        }
        guard let response = mockResponse as? T else {
            throw NetworkError.invalidResponse
        }
        return response
    }
}

private class MockErrorMapper: ErrorMapper {
    var mappedError: DomainError = .unexpected
    
    func mapTo(_ error: NetworkError) -> DomainError {
        return mappedError
    }
} 
