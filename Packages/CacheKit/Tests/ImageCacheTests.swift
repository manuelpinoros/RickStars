//
//  ImageCacheTests.swift
//  CacheKit
//
//  Created by Manuel Pino Ros on 12/6/25.
//

import XCTest
@testable import CacheKit

final class ImageCacheTests: XCTestCase {

    // Helper that always gives a unique URL
    private func makeURL(_ id: Int = Int.random(in: 0...1_000)) -> URL {
        URL(string: "https://example.com/img\(id).png")!
    }

    // MARK: - Happy path

    func testPutAndGetReturnsSameImage() {
        let cache = MemoryImageCache()
        let url   = makeURL()
        let img   = UIImage(systemName: "checkmark")!

        cache[url] = img

        XCTAssertEqual(cache[url], img, "Stored image should be returned for same URL")
    }

    func testOverrideUpdatesValue() {
        let cache = MemoryImageCache()
        let url   = makeURL()
        let first  = UIImage(systemName: "checkmark")!
        let second = UIImage(systemName: "xmark")!

        cache[url] = first
        cache[url] = second   // override

        XCTAssertEqual(cache[url], second, "Latest image should replace previous one")
    }

    // MARK: - Deletion

    func testSetNilRemovesEntry() {
        let cache = MemoryImageCache()
        let url   = makeURL()
        cache[url] = UIImage(systemName: "checkmark")

        cache[url] = nil      // explicit removal

        XCTAssertNil(cache[url], "Setting nil should delete entry for URL")
    }

    func testRemoveAllClearsEntireCache() {
        let cache = MemoryImageCache()
        (0..<5).forEach { cache[makeURL($0)] = UIImage(systemName: "photo") }

        cache.removeAll()

        (0..<5).forEach { XCTAssertNil(cache[makeURL($0)], "Cache should be empty after removeAll") }
    }

    // MARK: - Thread-safety (basic)

    func testConcurrentWritesAreSafe() {
        let cache      = MemoryImageCache()
        let iterations = 500
        let queue      = DispatchQueue(label: "concurrentWrites", attributes: .concurrent)
        let group      = DispatchGroup()

        (0..<iterations).forEach { i in
            group.enter()
            queue.async {
                cache[self.makeURL(i)] = UIImage(systemName: "photo")
                group.leave()
            }
        }

        // Wait until all writes finish (with 1-second timeout)
        let finished = group.wait(timeout: .now() + 1)
        XCTAssertEqual(finished, .success, "Writes should finish without deadlock")
    }
}
