import XCTest
@testable import RickMortyData
@testable import NetworkKit

final class RickMortyRouteTests: XCTestCase {
    func testCharactersEndpointWithPageAndName() {
        // Given
        let route = RickMortyRoute.characters(page: 1, name: "Rick")
        
        // When
        let endpoint = route.endpoint
        
        // Then
        XCTAssertEqual(endpoint.baseURL, URL(string: "https://rickandmortyapi.com/api")!)
        XCTAssertEqual(endpoint.path, "character")
        XCTAssertEqual(endpoint.query.count, 2)
        XCTAssertEqual(endpoint.query.first(where: { $0.name == "page" })?.value, "1")
        XCTAssertEqual(endpoint.query.first(where: { $0.name == "name" })?.value, "Rick")
    }
    
    func testCharactersEndpointWithPageOnly() {
        // Given
        let route = RickMortyRoute.characters(page: 1, name: nil)
        
        // When
        let endpoint = route.endpoint
        
        // Then
        XCTAssertEqual(endpoint.baseURL, URL(string: "https://rickandmortyapi.com/api")!)
        XCTAssertEqual(endpoint.path, "character")
        XCTAssertEqual(endpoint.query.count, 1)
        XCTAssertEqual(endpoint.query.first?.name, "page")
        XCTAssertEqual(endpoint.query.first?.value, "1")
    }
    
    func testMultipleCharactersEndpoint() {
        // Given
        let route = RickMortyRoute.multipleCharacters(ids: [1, 2, 3])
        
        // When
        let endpoint = route.endpoint
        
        // Then
        XCTAssertEqual(endpoint.baseURL, URL(string: "https://rickandmortyapi.com/api")!)
        XCTAssertEqual(endpoint.path, "character/1,2,3")
        XCTAssertEqual([], endpoint.query)
    }
    
    func testLocationEndpoint() {
        // Given
        let route = RickMortyRoute.location(id: 1)
        
        // When
        let endpoint = route.endpoint
        
        // Then
        XCTAssertEqual(endpoint.baseURL, URL(string: "https://rickandmortyapi.com/api")!)
        XCTAssertEqual(endpoint.path, "location/1")
        XCTAssertEqual([], endpoint.query)
    }
    
    func testLocationSearchEndpoint() {
        // Given
        let route = RickMortyRoute.locationSearch(name: "Earth")
        
        // When
        let endpoint = route.endpoint
        
        // Then
        XCTAssertEqual(endpoint.baseURL, URL(string: "https://rickandmortyapi.com/api")!)
        XCTAssertEqual(endpoint.path, "location")
        XCTAssertEqual(endpoint.query.count, 1)
        XCTAssertEqual(endpoint.query.first?.name, "name")
        XCTAssertEqual(endpoint.query.first?.value, "Earth")
    }
    
    func testEpisodesEndpoint() {
        // Given
        let route = RickMortyRoute.episodes(page: 1)
        
        // When
        let endpoint = route.endpoint
        
        // Then
        XCTAssertEqual(endpoint.baseURL, URL(string: "https://rickandmortyapi.com/api")!)
        XCTAssertEqual(endpoint.path, "episode")
        XCTAssertEqual(endpoint.query.count, 1)
        XCTAssertEqual(endpoint.query.first?.name, "page")
        XCTAssertEqual(endpoint.query.first?.value, "1")
    }
    
    func testMultipleEpisodesEndpoint() {
        // Given
        let route = RickMortyRoute.multipleEpisodes(ids: [1, 2, 3])
        
        // When
        let endpoint = route.endpoint
        
        // Then
        XCTAssertEqual(endpoint.baseURL, URL(string: "https://rickandmortyapi.com/api")!)
        XCTAssertEqual(endpoint.path, "episode/1,2,3")
        XCTAssertEqual([], endpoint.query)
    }
} 
