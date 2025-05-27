//
//  NetworkClient+Error.swift
//  NetworkKit
//
//  Created by Manuel Pino Ros on 27/5/25.
//
import Foundation

public enum NetworkError: Error {
    case invalidResponse
    case badStatusCode(Int)
    case decodingError(Error)
    case urlError(URLError)
    case cancelled                     // task or URLSession cancelled
    case unknown(Error)
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidResponse: return "La respuesta del servidor no es válida."
        case .badStatusCode(let code): return "Error HTTP \(code)."
        case .decodingError: return "No se pudo interpretar la respuesta."
        case .urlError(let e): return e.localizedDescription
        case .cancelled: return nil                       // silencio
        case .unknown(let e): return e.localizedDescription
        }
    }
}
