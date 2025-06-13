import XCTest
@testable import RickMortyData
@testable import NetworkKit
@testable import RickMortyDomain

final class DefaultEpisodeRepositoryTests: XCTestCase {
    private var sut: DefaultEpisodeRepository!
    private var mockClient: MockNetworkClient!
    private var mockErrorMapper: MockErrorMapper!
    
    override func setUp() {
        super.setUp()
        mockClient = MockNetworkClient()
        mockErrorMapper = MockErrorMapper()
        sut = DefaultEpisodeRepository(client: mockClient, errorMapper: mockErrorMapper)
    }
    
    override func tearDown() {
        sut = nil
        mockClient = nil
        mockErrorMapper = nil
        super.tearDown()
    }
    
    func testEpisodesWhenSuccessfulReturnsMappedEpisodes() async throws {
        // Given
        let expectedResponse = EpisodePageResponse(
            info: PageEpInfoResponse(next: "next-page"),
            results: [
                EpisodeResponse(
                    id: 1,
                    name: "Pilot",
                    airDate: "December 2, 2013",
                    code: "S01E01",
                    characters: ["https://rickandmortyapi.com/api/character/1"],
                    url: "https://rickandmortyapi.com/api/episode/1",
                    created: "2017-11-10T12:56:33.798Z"
                )
            ]
        )
        mockClient.mockResponse = expectedResponse
        
        // When
        let result = try await sut.episodes(page: 1)
        
        // Then
        XCTAssertEqual(result.info.next, "next-page")
        XCTAssertEqual(result.results.count, 1)
        XCTAssertEqual(result.results[0].id, 1)
        XCTAssertEqual(result.results[0].name, "Pilot")
        XCTAssertEqual(result.results[0].code, "S01E01")
    }
    
    func testEpisodesWhenNetworkErrorThrowsMappedError() async {
        // Given
        let networkError = NetworkError.invalidResponse
        mockClient.mockError = networkError
        mockErrorMapper.mappedError = DomainError.resourceNotFound
        
        // When/Then
        do {
            _ = try await sut.episodes(page: 1)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? DomainError, .resourceNotFound)
        }
    }
    
    func testEpisodesWithNameWhenSuccessfulReturnsFilteredEpisodes() async throws {
        // Given
        let expectedResponse = EpisodePageResponse(
            info: PageEpInfoResponse(next: nil),
            results: [
                EpisodeResponse(
                    id: 1,
                    name: "Pilot",
                    airDate: "December 2, 2013",
                    code: "S01E01",
                    characters: ["https://rickandmortyapi.com/api/character/1"],
                    url: "https://rickandmortyapi.com/api/episode/1",
                    created: "2017-11-10T12:56:33.798Z"
                )
            ]
        )
        mockClient.mockResponse = expectedResponse
        
        // When
        let result = try await sut.episodes(page: 1)
        
        // Then
        XCTAssertEqual(result.results.count, 1)
        XCTAssertEqual(result.results[0].name, "Pilot")
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
