//
//  CharacterPageResponse.swift
//  RickMortyData
//
//  Created by Manuel Pino Ros on 4/6/25.
//
import Foundation

struct CharacterPageResponse: Decodable {
    let info: PageInfoResponse
    let results: [CharacterResponse]
}

struct PageInfoResponse: Decodable {
    let next: String?
}

struct CharacterResponse: Decodable {
    let id: Int
    let name: String
    let status: String      // “Alive”, “Dead”, “unknown”
    let species: String
    let image: URL
    let origin: OriginResponse
    let location: LocationResponse
}

struct OriginResponse: Decodable {
    let name: String
    let url: String
}

struct LocationResponse: Decodable {
    let name: String
    let url: String
}
