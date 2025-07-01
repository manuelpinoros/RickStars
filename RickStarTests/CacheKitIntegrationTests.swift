//
//  CacheKitIntegrationTests.swift
//  RickStar
//
//  Created by Manuel Pino Ros on 1/7/25.
//


import XCTest
@testable import CacheKit

final class CacheKitIntegrationTests: XCTestCase {
    func testStoreAndRetrieveImage() {
        let cache = MemoryImageCache()
        let url = URL(string: "https://example.com/image.png")!
        let image = UIImage(systemName: "star")!

        cache[url] = image
        let retrieved = cache[url]

        XCTAssertNotNil(retrieved)
        XCTAssertEqual(retrieved?.pngData(), image.pngData())
    }

    func testRemoveImage() {
        let cache = MemoryImageCache()
        let url = URL(string: "https://example.com/image.png")!
        let image = UIImage(systemName: "star")!

        cache[url] = image
        cache[url] = nil

        XCTAssertNil(cache[url])
    }

    func testRemoveAllImages() {
        let cache = MemoryImageCache()
        let url1 = URL(string: "https://example.com/image1.png")!
        let url2 = URL(string: "https://example.com/image2.png")!
        let image = UIImage(systemName: "star")!

        cache[url1] = image
        cache[url2] = image

        cache.removeAll()

        XCTAssertNil(cache[url1])
        XCTAssertNil(cache[url2])
    }
}