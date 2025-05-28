//
//  NetworkClient+Error.swift
//  NetworkKit
//
//  Created by Manuel Pino Ros on 27/5/25.
//
import Foundation

public enum NetworkError: Error, Equatable {
    case invalidResponse
    case badStatusCode(Int)
    case decodingError(Error)
    case urlError(URLError)
    case cancelled
    case unknown(Error)
    
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidResponse, .invalidResponse):
            return true
        case (.badStatusCode(let lhsCode), .badStatusCode(let rhsCode)):
            return lhsCode == rhsCode
        case (.cancelled, .cancelled):
            return true
        case (.urlError(let lhsError), .urlError(let rhsError)):
            return lhsError.code == rhsError.code
        case (.decodingError, .decodingError),
             (.unknown, .unknown):
            return true
        default:
            return false
        }
    }
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidResponse: return "The server response is not valid."
        case .badStatusCode(let code): return "Error HTTP \(code)."
        case .decodingError: return "The response could not be parsed."
        case .urlError(let e): return e.localizedDescription
        case .cancelled: return nil
        case .unknown(let e): return e.localizedDescription
        }
    }
}
