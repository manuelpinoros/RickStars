//
//  EpisodePageResponse.swift
//  RickMortyData
//
//  Created by Manuel Pino Ros on 4/6/25.
//
import Foundation

public struct EpisodePageResponse: Decodable {
    let info: PageEpInfoResponse
    let results: [EpisodeResponse]
}

struct PageEpInfoResponse: Decodable {
    let next: String?
}

public struct EpisodeResponse: Decodable{
    let id: Int
    let name: String
    let airDate: String
    let code: String
    let characters: [String]
    let url: String
    let created: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case airDate = "air_date"
        case code    = "episode"
        case characters, url, created
    }
}
