//
//  EpisodePage.swift
//  RickMortyDomain
//
//  Created by Manuel Pino Ros on 27/5/25.
//


import Foundation

public struct EpisodePage: Decodable {
    public let info: PageInfo
    public let results: [Episode]
}

public struct Episode: Decodable, Identifiable, Equatable, Hashable {
    public let id: Int
    public let name: String
    public let airDate: String
    public let code: String
    public let characters: [String]
    public let url: String
    public let created: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case airDate = "air_date"
        case code    = "episode"
        case characters, url, created
    }
}
