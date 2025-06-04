//
//  CharacterDetailViewModel.swift
//  RickStar
//
//  Created by Manuel Pino Ros on 27/5/25.
//


import Foundation
import SwiftUI
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
    let character: Character
    var episodes: [Episode] = []

    init(
        character: Character,
        episodeRepo: EpisodeRepository = DefaultEpisodeRepository()
    ) {
        self.character = character
        self.episodeRepo = episodeRepo
    }

    func loadEpisodes() async throws {
        guard episodes.isEmpty else { return }
        
        let ids = character.episode
            .compactMap { URL(string: $0)?.lastPathComponent }
            .compactMap(Int.init)
        
        guard !ids.isEmpty else {
            throw EpisodeLoadError.noEpisodeIds
        }
        
        episodes = try await episodeRepo.episodes(ids: ids)
    }
}
