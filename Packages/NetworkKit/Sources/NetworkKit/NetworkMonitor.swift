//
//  NetworkMonitor.swift
//  NetworkKit
//
//  Created by Manuel Pino Ros on 27/5/25.
//
import Foundation
import Network
import Combine

//MARK: NetworkPathMonitorProtocol
protocol NetworkPathMonitorProtocol: Sendable {
    func start(queue: DispatchQueue)
    var currentPath: NWPath { get }
    var pathUpdateHandler: (@Sendable (_ newPath: NWPath) -> Void)? { get set }
}

extension NWPathMonitor: NetworkPathMonitorProtocol {}

//MARK: NetworkPath
public struct NetworkPath {
    public var status: NWPath.Status
    
    public init(status: NWPath.Status) {
        self.status = status
    }
}

extension NetworkPath {
    public init(rawValue: NWPath) {
        self.status = rawValue.status
    }
}

extension NetworkPath: Equatable {}

//MARK: PathCreation
protocol PathCreationProtocol {
    var networkPathPublisher: AnyPublisher<NetworkPath, Never>? { get }
    func start()
}

final class PathCreation: PathCreationProtocol {
    public var networkPathPublisher: AnyPublisher<NetworkPath, Never>?
    private let subject = PassthroughSubject<NWPath, Never>()
    private let monitor = NWPathMonitor()
    
    func start() {
        monitor.pathUpdateHandler = subject.send
        networkPathPublisher = subject
            .handleEvents(
                receiveSubscription: { _ in self.monitor.start(queue: .main) },
                receiveCancel: monitor.cancel
            )
            .map(NetworkPath.init(rawValue:))
            .eraseToAnyPublisher()
    }
}

//MARK: Utilitie class
public final class NetworkPathMonitor: ObservableObject {
    @Published var isConnected = true
    
    private var pathUpdateCancellable: AnyCancellable?
    let paths: PathCreationProtocol
    
    init(
        paths: PathCreationProtocol = PathCreation()
    ) {
        self.paths = paths
        paths.start()
        self.pathUpdateCancellable = paths.networkPathPublisher?
            .sink(receiveValue: { [weak self] isConnected in
                self?.isConnected = isConnected == NetworkPath(status: .satisfied)
            })
    }
}
