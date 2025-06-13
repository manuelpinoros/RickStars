import XCTest
@testable import RickMortyData
@testable import NetworkKit
@testable import RickMortyDomain

final class NetworkErrorMapperTests: XCTestCase {
    private var sut: NetworkErrorMapper!
    
    override func setUp() {
        super.setUp()
        sut = NetworkErrorMapper()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testMapToBadStatusCode404ReturnsResourceNotFound() {
        // Given
        let networkError = NetworkError.badStatusCode(404)
        
        // When
        let result = sut.mapTo(networkError)
        
        // Then
        XCTAssertEqual(result, .resourceNotFound)
    }
    
    func testMapToBadStatusCode503ReturnsMaintenance() {
        // Given
        let networkError = NetworkError.badStatusCode(503)
        
        // When
        let result = sut.mapTo(networkError)
        
        // Then
        XCTAssertEqual(result, .maintenance)
    }
    
    func testMapToBadStatusCodeOtherReturnsUnexpected() {
        // Given
        let networkError = NetworkError.badStatusCode(500)
        
        // When
        let result = sut.mapTo(networkError)
        
        // Then
        XCTAssertEqual(result, .unexpected)
    }
    
    func testMapToURLErrorNotConnectedToInternetReturnsConnectivity() {
        // Given
        let networkError = NetworkError.urlError(URLError(.notConnectedToInternet))
        
        // When
        let result = sut.mapTo(networkError)
        
        // Then
        XCTAssertEqual(result, .connectivity)
    }
    
    func testMapToURLErrorNetworkConnectionLostReturnsConnectivity() {
        // Given
        let networkError = NetworkError.urlError(URLError(.networkConnectionLost))
        
        // When
        let result = sut.mapTo(networkError)
        
        // Then
        XCTAssertEqual(result, .connectivity)
    }
    
    func testMapToURLErrorTimedOutReturnsConnectivity() {
        // Given
        let networkError = NetworkError.urlError(URLError(.timedOut))
        
        // When
        let result = sut.mapTo(networkError)
        
        // Then
        XCTAssertEqual(result, .connectivity)
    }
    
    func testMapToURLErrorCancelledReturnsCancelled() {
        // Given
        let networkError = NetworkError.urlError(URLError(.cancelled))
        
        // When
        let result = sut.mapTo(networkError)
        
        // Then
        XCTAssertEqual(result, .cancelled)
    }
    
    func testMapToURLErrorOtherReturnsUnexpected() {
        // Given
        let networkError = NetworkError.urlError(URLError(.badURL))
        
        // When
        let result = sut.mapTo(networkError)
        
        // Then
        XCTAssertEqual(result, .unexpected)
    }
    
    func testMapToInvalidResponseReturnsUnexpected() {
        // Given
        let networkError = NetworkError.invalidResponse
        
        // When
        let result = sut.mapTo(networkError)
        
        // Then
        XCTAssertEqual(result, .unexpected)
    }
    
    func testMapToDecodingErrorReturnsUnexpected() {
        // Given
        let networkError = NetworkError.decodingError(NSError(domain: "test", code: 0))
        
        // When
        let result = sut.mapTo(networkError)
        
        // Then
        XCTAssertEqual(result, .unexpected)
    }
    
    func testMapToUnknownReturnsUnexpected() {
        // Given
        let networkError = NetworkError.unknown(NSError(domain: "test", code: 0))
        
        // When
        let result = sut.mapTo(networkError)
        
        // Then
        XCTAssertEqual(result, .unexpected)
    }
    
    func testMapToCancelledReturnsCancelled() {
        // Given
        let networkError = NetworkError.cancelled
        
        // When
        let result = sut.mapTo(networkError)
        
        // Then
        XCTAssertEqual(result, .cancelled)
    }
} 
