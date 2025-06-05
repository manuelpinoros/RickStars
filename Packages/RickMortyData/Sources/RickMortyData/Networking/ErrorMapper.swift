//
//  ErrorMapper.swift
//  RickMortyData
//
//  Created by Manuel Pino Ros on 4/6/25.
//

import Foundation
import NetworkKit
import RickMortyDomain

public protocol ErrorMapper {
    func map(_ error: NetworkError) -> DomainError
}

public struct NetworkErrorMapper: ErrorMapper {
    public init() {}

    public func map(_ error: NetworkError) -> DomainError {
        switch error {
            
        case .badStatusCode(let code):
            switch code {
            
            case 404: return .resourceNotFound
            case 503: return .maintenance
            default:  return .unexpected
            }

        case .urlError(let urlError):
            switch urlError.code {
            case .notConnectedToInternet,
                 .networkConnectionLost,
                 .timedOut:
                return .connectivity
            case .cancelled:
                return .cancelled
            default:
                return .unexpected
            }

        case .invalidResponse,
             .decodingError,
             .unknown:
            return .unexpected

        case .cancelled:
            return .cancelled
        }
    }
}
