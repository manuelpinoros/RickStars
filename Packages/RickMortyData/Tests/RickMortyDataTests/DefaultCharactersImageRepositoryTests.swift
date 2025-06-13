import XCTest
@testable import RickMortyData
@testable import RickMortyDomain

import UIKit

final class DefaultCharactersImageRepositoryTests: XCTestCase {
    private var sut: DefaultCharactersImageRepository!
    private var mockLocal: MockCharactersImageLocalDatasource!
    private var mockRemote: MockCharactersImageRemoteDatasource!
    
    override func setUp() {
        super.setUp()
        mockLocal = MockCharactersImageLocalDatasource()
        mockRemote = MockCharactersImageRemoteDatasource()
        sut = DefaultCharactersImageRepository(local: mockLocal, remote: mockRemote)
    }
    
    override func tearDown() {
        sut = nil
        mockLocal = nil
        mockRemote = nil
        super.tearDown()
    }
    
    func testLoadImageWhenLocalHasImageReturnsLocalImage() async throws {
        // Given
        let url = URL(string: "https://example.com/image.jpg")!
        let expectedImage = UIImage()
        mockLocal.mockCachedImage = expectedImage
        
        // When
        let result = try await sut.loadImage(from: url)
        
        // Then
        XCTAssertEqual(result, expectedImage)
        XCTAssertFalse(mockRemote.downloadImageCalled)
    }
    
    func testLoadImageWhenLocalFailsDownloadsFromRemote() async throws {
        // Given
        let url = URL(string: "https://example.com/image.jpg")!
        let downloadedImage = UIImage()
        mockLocal.mockCachedImage = nil
        mockRemote.mockDownloadedImage = downloadedImage
        
        // When
        let result = try await sut.loadImage(from: url)
        
        // Then
        XCTAssertEqual(result, downloadedImage)
        XCTAssertTrue(mockRemote.downloadImageCalled)
        XCTAssertEqual(mockLocal.savedImage, downloadedImage)
        XCTAssertEqual(mockLocal.savedURL, url)
    }
    
    func testLoadImageWhenBothSourcesFailThrowsError() async {
        // Given
        let url = URL(string: "https://example.com/image.jpg")!
        mockLocal.mockCachedImage = nil
        mockRemote.mockError = DomainError.resourceNotFound
        
        // When/Then
        do {
            _ = try await sut.loadImage(from: url)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? DomainError, .resourceNotFound)
        }
    }
}

// MARK: - Mocks
private class MockCharactersImageLocalDatasource: CharacterImageSource {
    var mockCachedImage: UIImage?
    var savedImage: UIImage?
    var savedURL: URL?
    private var cache = NSCache<NSURL, UIImage>()
    
    func imageFromSource(url: URL) async throws -> UIImage {
        guard let image = mockCachedImage else {
            throw DomainError.localResourceNotFound
        }
        return image
    }
    
    func imageToSource(_ image: UIImage, url: URL) {
        savedImage = image
        savedURL = url
        cache.setObject(image, forKey: url as NSURL)
    }
}

private class MockCharactersImageRemoteDatasource: CharacterImageSource {
    var mockDownloadedImage: UIImage?
    var mockError: Error?
    var downloadImageCalled = false
    
    func imageFromSource(url: URL) async throws -> UIImage {
        downloadImageCalled = true
        if let error = mockError {
            throw error
        }
        guard let image = mockDownloadedImage else {
            throw DomainError.resourceNotFound
        }
        return image
    }
    
    func imageToSource(_ image: UIImage, url: URL) {}
} 
