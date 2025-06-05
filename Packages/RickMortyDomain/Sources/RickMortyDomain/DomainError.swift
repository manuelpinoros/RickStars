//
//  DomainError.swift
//  RickMortyData
//
//  Created by Manuel Pino Ros on 4/6/25.
//

import Foundation

public enum DomainError: Error, Equatable {
    
    case resourceNotFound
    case maintenance
    case connectivity
    case cancelled
    case unexpected
}

extension DomainError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .resourceNotFound:   return "Resource not found."
        case .maintenance:        return "Maintenance, please try later."
        case .connectivity:       return "Check your internet connection."
        case .cancelled:          return nil            
        case .unexpected:         return "Unexpected error occurred."
        }
    }
}
