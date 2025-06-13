//
//  Constants.swift
//  RickStar
//
//  Created by Manuel Pino Ros on 27/5/25.
//
import SwiftUI

let unexpectedErrorMessage: String = "Unexpected error"

enum ButtonShape{
    case circle
    case rounded
}

enum CharacterStatus: String {
    case alive = "alive"
    case dead = "dead"
    case unknown = "unknown"
    
    var statusColor: Color {
        switch self {
        case .alive:
            return .green
        case .dead:
            return .red
        case .unknown:
            return .yellow
        }
    }
}
