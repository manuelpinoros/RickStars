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
@Observable
public final class NetworkMonitor{

    //Simple singleton to check network
    public static let shared = NetworkMonitor()
    
    public private(set) var isConnected: Bool = true
    public private(set) var interfaceType: NWInterface.InterfaceType?
    
    private let monitor = NWPathMonitor()
    private let queue   = DispatchQueue(label: "NetworkMonitorQueue")
    
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
