//
//  EpisodeRepository.swift
//  RickMortyDomain
//
//  Created by Manuel Pino Ros on 27/5/25.
//

public protocol EpisodeRepository {
    func episodes(page: Int) async throws -> EpisodePage
    func episodes(ids: [Int]) async throws -> [Episode]
}
