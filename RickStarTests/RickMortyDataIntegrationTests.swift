//
//  RickMortyDataIntegrationTests.swift
//  RickStar
//
//  Created by Manuel Pino Ros on 1/7/25.
//


import XCTest
@testable import RickMortyData
@testable import NetworkKit
@testable import RickMortyDomain

final class RickMortyDataIntegrationTests: XCTestCase {
    // MARK: - Character Repository Integration
    func testCharacterRepositoryIntegrationReturnsExpectedCharacters() async throws {
        let stubClient = StubNetworkClient_Character()
        let repo = DefaultCharacterRepository(client: stubClient, errorMapper: NetworkErrorMapper())
        
        let result = try await repo.characters(page: 1)
        XCTAssertEqual(result.results.count, 1)
        XCTAssertEqual(result.results[0].name, "Rick")
        XCTAssertEqual(result.info.next, "next-page")
    }
    
    // MARK: - Episode Repository Integration
    func testEpisodeRepositoryIntegrationReturnsExpectedEpisodes() async throws {
        let stubClient = StubNetworkClient_Episode()
        let repo = DefaultEpisodeRepository(client: stubClient, errorMapper: NetworkErrorMapper())
        
        let result = try await repo.episodes(page: 1)
        XCTAssertEqual(result.results.count, 1)
        XCTAssertEqual(result.results[0].name, "Pilot")
        XCTAssertEqual(result.info.next, "next-ep")
    }
    
    // MARK: - Characters Image Repository Integration
    func testCharactersImageRepositoryIntegrationCachesAndLoadsImage() async throws {
        let local = InMemoryImageSource()
        let remote = InMemoryImageSource()
        let repo = DefaultCharactersImageRepository(local: local, remote: remote)
        
        let url = URL(string: "https://example.com/image.png")!
        let image = UIImage(systemName: "star")!
        
        // Simulate remote having the image, local does not
        remote.imageToSource(image, url: url)
        
        // First load: should fetch from remote and cache locally
        let loaded = try await repo.loadImage(from: url)
        XCTAssertEqual(loaded.pngData(), image.pngData())
        
        // Remove from remote, should still be available locally
        remote.removeAll()
        let loadedAgain = try await repo.loadImage(from: url)
        XCTAssertEqual(loadedAgain.pngData(), image.pngData())
    }
}

// MARK: - Stub Network Clients

final class StubNetworkClient_Character: NetworkClient {
    func request<T>(_ endpoint: Endpoint) async throws -> T where T : Decodable {
        let json = """
        {
            "info": { "next": "next-page" },
            "results": [{
                "id": 1,
                "name": "Rick",
                "status": "Alive",
                "species": "Human",
                "type": "",
                "origin": { "name": "Earth", "url": "url" },
                "location": { "name": "Earth", "url": "url" },
                "episode": ["episode1"],
                "image": "https://example.com"
            }]
        }
        """
        let data = json.data(using: .utf8)!
        return try JSONDecoder().decode(T.self, from: data)
    }
}

final class StubNetworkClient_Episode: NetworkClient {
    func request<T>(_ endpoint: Endpoint) async throws -> T where T : Decodable {
        let json = """
        {
            "info": { "next": "next-ep" },
            "results": [{
                "id": 1,
                "name": "Pilot",
                "air_date": "December 2, 2013",
                "episode": "S01E01",
                "characters": ["https://example.com/character/1"],
                "url": "https://example.com/episode/1",
                "created": "2017-11-10T12:56:33.798Z"
            }]
        }
        """
        let data = json.data(using: .utf8)!
        return try JSONDecoder().decode(T.self, from: data)
    }
}

// MARK: - In-Memory Image Source

final class InMemoryImageSource: CharacterImageSource {
    private var cache = [URL: UIImage]()
    
    func imageFromSource(url: URL) async throws -> UIImage {
        guard let image = cache[url] else {
            throw DomainError.localResourceNotFound
        }
        return image
    }
    
    func imageToSource(_ image: UIImage, url: URL) {
        cache[url] = image
    }
    
    func removeAll() {
        cache.removeAll()
    }
}
