//
//  DefaultCharacterRepository.swift
//  RickMortyData
//
//  Created by Manuel Pino Ros on 27/5/25.
//
import Foundation
import NetworkKit

public final class DefaultCharacterRepository: CharacterRepository {
    private let client: NetworkClient
    
    public func characters(page: Int) async throws -> CharacterPage {
        let dto: CharacterPageResponse = try await client.request(
            RickMortyRoute.characters(page: page, name: nil).endpoint
        )
        return map(dto)
    }
    
    public init(client: NetworkClient = URLSessionClient()) {
        self.client = client
    }

    public func characters(page: Int, name: String?) async throws -> CharacterPage {
        let dto: CharacterPageResponse = try await client.request(
            RickMortyRoute.characters(page: page, name: name).endpoint
        )
        return map(dto)
    }

    // MARK: - Mapping
    private func map(_ dto: CharacterPageResponse) -> CharacterPage {
        CharacterPage(
            info: PageInfo(next: dto.info.next),
            results: dto.results.map(map(_:))
        )
    }

    private func map(_ dto: CharacterResponse) -> Character {
        Character(
            id: dto.id,
            name: dto.name,
            status: dto.status,
            species: dto.species,
            type: dto.type,
            origin: ROrigin(name: dto.origin.name,
                            url: dto.origin.url),
            location: RLocation(name: dto.location.name,
                                url: dto.location.url),
            episode: dto.episode,
            image: dto.image
        )
    }
}
