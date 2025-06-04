//
//  DefaultEpisodeRepository.swift
//  RickMortyData
//
//  Created by Manuel Pino Ros on 27/5/25.
//
import Foundation
import NetworkKit

public final class DefaultEpisodeRepository: EpisodeRepository {

    private let client: NetworkClient

    public init(client: NetworkClient = URLSessionClient()) {
        self.client = client
    }

    // MARK: - Public API
    public func episodes(page: Int) async throws -> EpisodePage {
        let endpoint = RickMortyRoute.episodes(page: page).endpoint
        let dto: EpisodePageResponse = try await client.request(endpoint)
        return map(dto)
    }

    public func episodes(ids: [Int]) async throws -> [Episode] {
        let endpoint = RickMortyRoute.multipleEpisodes(ids: ids).endpoint

        if ids.count == 1 {
            let dto: EpisodeResponse = try await client.request(endpoint)
            return [map(dto)]
        } else {
            let dtos: [EpisodeResponse] = try await client.request(endpoint)
            return dtos.map(map)
        }
    }

    // MARK: - Mapping helpers

    private func map(_ dto: EpisodePageResponse) -> EpisodePage {
        EpisodePage(
            info: PageEpInfo(next: dto.info.next),
            results: dto.results.map(map)
        )
    }

    private func map(_ dto: EpisodeResponse) -> Episode {
        Episode(
            id: dto.id,
            name: dto.name,
            airDate: dto.airDate,
            code: dto.code,
            characters: dto.characters,
            url: dto.url,
            created: dto.created
        )
    }
}
