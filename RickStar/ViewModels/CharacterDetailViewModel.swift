//
//  CharacterDetailViewModel.swift
//  RickStar
//
//  Created by Manuel Pino Ros on 27/5/25.
//


import Foundation
import SwiftUI
import RickMortyDomain
import RickMortyData

enum EpisodeLoadError: LocalizedError {
    case noEpisodeIds
    var errorDescription: String? {
        switch self {
        case .noEpisodeIds:
            return "Character does not appear in any episode"
        }
    }
}

@MainActor
@Observable
final class CharacterDetailViewModel {
    
    private let episodeRepo: EpisodeRepository
    let rickCharacter: RickCharacter
    var episodes: [Episode] = []

    init(
        rickCharacter: RickCharacter,
        episodeRepo: EpisodeRepository = DefaultEpisodeRepository()
    ) {
        self.rickCharacter = rickCharacter
        self.episodeRepo = episodeRepo
    }

    func loadEpisodes() async throws {
        guard episodes.isEmpty else { return }
        
        let ids = rickCharacter.episode
            .compactMap { URL(string: $0)?.lastPathComponent }
            .compactMap(Int.init)
        
        guard !ids.isEmpty else {
            throw EpisodeLoadError.noEpisodeIds
        }
        
        episodes = try await episodeRepo.episodes(ids: ids)
    }
}
