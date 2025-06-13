//
//  DefaultCharacterRepository.swift
//  RickMortyData
//
//  Created by Manuel Pino Ros on 27/5/25.
//
import Foundation
import NetworkKit
import RickMortyDomain

public final class DefaultCharacterRepository: CharacterRepository {
    private let client: NetworkClient
    private let errorMapper: ErrorMapper
    
    public func characters(page: Int) async throws -> CharacterPage {
        do {
            let dto: CharacterPageResponse = try await client.request(
                RickMortyRoute.characters(page: page, name: nil).endpoint
            )
            return map(dto)
        } catch let netError as NetworkError {
            throw errorMapper.mapTo(netError)
        } catch {
            throw DomainError.unexpected
        }
    }
    
    public init(client: NetworkClient, errorMapper: ErrorMapper) {
        self.client = client
        self.errorMapper = errorMapper
    }

    public convenience init() {
        self.init(client: URLSessionClient(),
                  errorMapper: NetworkErrorMapper())
    }

    public func characters(page: Int, name: String?) async throws -> CharacterPage {
        do {
            let dto: CharacterPageResponse = try await client.request(
                RickMortyRoute.characters(page: page, name: name).endpoint
            )
            return map(dto)
        } catch let netError as NetworkError {
            throw errorMapper.mapTo(netError)
        } catch {
            throw DomainError.unexpected
        }
    }

    // MARK: - Mapping
    private func map(_ dto: CharacterPageResponse) -> CharacterPage {
        CharacterPage(
            info: PageInfo(next: dto.info.next),
            results: dto.results.map(map(_:))
        )
    }

    private func map(_ dto: CharacterResponse) -> RickCharacter {
        RickCharacter(
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
