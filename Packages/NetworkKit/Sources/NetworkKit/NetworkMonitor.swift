//
//  NetworkMonitor.swift
//  NetworkKit
//
//  Created by Manuel Pino Ros on 27/5/25.
//
import Foundation
import Network
import Combine

@MainActor
public final class NetworkMonitor: ObservableObject {
    public static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    private let queue   = DispatchQueue(label: "NetworkMonitorQueue")
    
    @Published public private(set) var isConnected: Bool = true
    @Published public private(set) var interfaceType: NWInterface.InterfaceType?
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor in
                self?.isConnected = path.status == .satisfied
                self?.interfaceType = path.availableInterfaces
                    .first(where: { path.usesInterfaceType($0.type) })?.type
            }
        }
        monitor.start(queue: queue)
    }
}
