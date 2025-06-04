//
//  Character.swift
//  RickMortyDomain
//
//  Created by Manuel Pino Ros on 27/5/25.
//

import Foundation

public struct CharacterPage {
    public let info: PageInfo
    public let results: [Character]
}

public struct PageInfo {
    public let next: String?
}

public struct Character: Identifiable, Equatable, Hashable {
    public let id: Int
    public let name: String
    public let status: String
    public let species: String
    public let type: String
    public let origin: ROrigin
    public let location: RLocation
    public let episode: [String]
    public let image: URL
}

public struct ROrigin: Equatable, Hashable {
    public let name: String
    public let url: String
}

public struct RLocation: Equatable, Hashable {
    public let name: String
    public let url: String
}
