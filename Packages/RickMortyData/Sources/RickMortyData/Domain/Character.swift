//
//  Character.swift
//  RickMortyDomain
//
//  Created by Manuel Pino Ros on 27/5/25.
//

import Foundation

public struct CharacterPage: Decodable {
    public let info: PageInfo
    public let results: [Character]
}

public struct PageInfo: Decodable {
    public let next: String?
}

public struct Character: Decodable, Identifiable, Equatable, Hashable {
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

public struct ROrigin: Decodable, Equatable, Hashable {
    public let name: String
    public let url: String
}

public struct RLocation: Decodable, Equatable, Hashable {
    public let name: String
    public let url: String
}
