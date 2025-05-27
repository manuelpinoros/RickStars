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

@MainActor
@Observable
final class CharacterDetailViewModel {
    
    let character: Character
    var episodes: [Episode] = []
    var episodesError: String?

    private let episodeRepo: EpisodeRepository

    init(
        character: Character,
        episodeRepo: EpisodeRepository = DefaultEpisodeRepository()
    ) {
        self.character = character
        self.episodeRepo = episodeRepo
    }

    func loadEpisodes() async {
        guard episodes.isEmpty else { return }

        let ids = character.episode
            .compactMap { URL(string: $0)?.lastPathComponent }
            .compactMap(Int.init)

        guard !ids.isEmpty else { return }

        do {
            episodes = try await episodeRepo.episodes(ids: ids)
        } catch {
            episodesError = error.localizedDescription
        }
    }
}
