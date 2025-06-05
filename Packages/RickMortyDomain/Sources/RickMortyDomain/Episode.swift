//
//  EpisodePage.swift
//  RickMortyDomain
//
//  Created by Manuel Pino Ros on 27/5/25.
//
import Foundation

public struct EpisodePage{
    public let info: PageEpInfo
    public let results: [Episode]

    public init(info: PageEpInfo, results: [Episode]) {
        self.info = info
        self.results = results
    }
}

public struct PageEpInfo: Decodable {
    public let next: String?

    public init(next: String?) {
        self.next = next
    }
}

public struct Episode: Identifiable, Equatable, Hashable {
    public let id: Int
    public let name: String
    public let airDate: String
    public let code: String
    public let characters: [String]
    public let url: String
    public let created: String

    public init(
        id: Int,
        name: String,
        airDate: String,
        code: String,
        characters: [String],
        url: String,
        created: String
    ) {
        self.id = id
        self.name = name
        self.airDate = airDate
        self.code = code
        self.characters = characters
        self.url = url
        self.created = created
    }

    enum CodingKeys: String, CodingKey {
        case id, name
        case airDate = "air_date"
        case code    = "episode"
        case characters, url, created
    }
}
