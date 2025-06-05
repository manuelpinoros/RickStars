//
//  Character.swift
//  RickMortyDomain
//
//  Created by Manuel Pino Ros on 27/5/25.
//

import Foundation

public struct CharacterPage {
    public let info: PageInfo
    public let results: [RickCharacter]

    public init(info: PageInfo, results: [RickCharacter]) {
        self.info = info
        self.results = results
    }
}

public struct PageInfo {
    public let next: String?

    public init(next: String?) {
        self.next = next
    }
}

public struct RickCharacter: Identifiable, Equatable, Hashable {
    public let id: Int
    public let name: String
    public let status: String
    public let species: String
    public let type: String
    public let origin: ROrigin
    public let location: RLocation
    public let episode: [String]
    public let image: URL

    public init(id: Int,
                name: String,
                status: String,
                species: String,
                type: String,
                origin: ROrigin,
                location: RLocation,
                episode: [String],
                image: URL) {
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.type = type
        self.origin = origin
        self.location = location
        self.episode = episode
        self.image = image
    }
}

public struct ROrigin: Equatable, Hashable {
    public let name: String
    public let url: String

    public init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}

public struct RLocation: Equatable, Hashable {
    public let name: String
    public let url: String

    public init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}
