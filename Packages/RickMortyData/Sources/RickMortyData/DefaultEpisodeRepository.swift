//
//  DefaultEpisodeRepository.swift
//  RickMortyData
//
//  Created by Manuel Pino Ros on 27/5/25.
//
import Foundation
import NetworkKit
import RickMortyDomain

public final class DefaultEpisodeRepository: EpisodeRepository {
    private let client: NetworkClient
    public init(client: NetworkClient = URLSessionClient()) {
      self.client = client
    }
    public func episodes(page: Int) async throws -> EpisodePage {
        let ep = RickMortyRoute.episodes(page: page).endpoint
        return try await client.request(ep)
    }

    public func episodes(ids: [Int]) async throws -> [Episode] {
        let ep = RickMortyRoute.multipleEpisodes(ids: ids).endpoint
        return try await client.request(ep)
    }
}
