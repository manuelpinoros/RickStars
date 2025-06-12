//
//  NetworkMonitorTests.swift
//  NetworkKit
//
//  Created by Manuel Pino Ros on 12/6/25.
//

import XCTest
import Combine

@testable import NetworkKit

final class NetworkMonitorTests: XCTestCase {

    func testInitialStateIsConnectedTrue() {
        let sut = NetworkPathMonitor(
            paths: MockPathCreation(status: .init(status: .satisfied))
        )

        XCTAssertTrue(sut.isConnected, "NetworkMonitor should default to `.satisfied` on launch (i.e. `isConnected == true`).")
       // XCTAssertNil(sut.interfaceType, "interfaceType should be `nil` until the first path-update callback arrives.")
    }
}

final class MockPathCreation: PathCreationProtocol {
    var status: NetworkPath
    var networkPathPublisher: AnyPublisher<NetworkPath, Never>?
    func start() {
        networkPathPublisher = .init(Just(status))
    }
    
    init(status: NetworkPath = NetworkPath(status: .requiresConnection)) {
        self.status = status
    }
}
