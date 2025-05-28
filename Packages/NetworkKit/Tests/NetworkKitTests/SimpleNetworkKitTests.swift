//
//  SimpleNetworkKitTests.swift
//  NetworkKit
//
//  Created by Manuel Pino Ros on 28/5/25.
//


import XCTest
@testable import NetworkKit

final class SimpleNetworkKitTests: XCTestCase {
    func testEndpointURLRequestBuilding() {
        let baseURL = URL(string: "https://example.com/api")!
        let endpoint = Endpoint(
            baseURL: baseURL,
            path: "items",
            query: [
                URLQueryItem(name: "page", value: "1"),
                URLQueryItem(name: "filter", value: "active")
            ]
        )
        let request = endpoint.urlRequest
        XCTAssertEqual(
            request.url?.absoluteString,
            "https://example.com/api/items?page=1&filter=active"
        )
        XCTAssertEqual(request.httpMethod, "GET")
    }

    func testNetworkErrorLocalizedDescription() {
        // Bad status code
        let badStatus = NetworkError.badStatusCode(404)
        XCTAssertEqual(badStatus.errorDescription, "Error HTTP 404.")

        // Invalid response
        let invalid = NetworkError.invalidResponse
        XCTAssertEqual(invalid.errorDescription, "La respuesta del servidor no es válida.")

        // Cancelled should be silent
        let cancelled = NetworkError.cancelled
        XCTAssertNil(cancelled.errorDescription)
    }
}
