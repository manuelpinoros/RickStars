//
//  CharacterDetailView.swift
//  RickStar
//
//  Created by Manuel Pino Ros on 27/5/25.
//
import SwiftUI
import RickMortyDomain
import RickMortyData

struct CharacterDetailView: View {
    let character: Character
    @State private var episodes: [Episode] = []
    @State private var episodesError: String? = nil
    private let episodeRepo = DefaultEpisodeRepository()
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            AsyncImage(url: character.image) { phase in
                switch phase {
                case .success(let img): img.resizable()
                default: ProgressView()
                }
            }
            .frame(width: 160, height: 160)
            .clipShape(Circle())
            .statusBorderCircle(CharacterStatus(rawValue: character.status.lowercased()) ?? .unknown, lineWidth: 4)
            .frame(maxWidth: .infinity)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    Text(character.name)
                        .font(.largeTitle)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Group {
                        DetailRow(
                            title: "Status:",
                            value: character.status
                        )
                        DetailRow(
                            title: "Species:",
                            value: character.species.isEmpty ? "Unknown" : character.species
                        )
                        DetailRow(
                            title: "Type:",
                            value: character.type.isEmpty ? "Unknown" : character.type
                        )
                        DetailRow(
                            title: "Origin:",
                            value: character.origin.name.isEmpty ? "Unknown" : character.origin.name
                        )
                        DetailRow(
                            title: "Last seen at:",
                            value: character.location.name.isEmpty ? "Unknown" : character.location.name
                        )
                        DetailRow(
                            title: "Appear in:",
                            value: "\(episodes.count) episodes"
                        )
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.cyan.opacity(0.4))
                        .innerRoundedBorder(color: .indigo, lineWidth: 4, cornerRadius: 12)
                )
                
                VStack(alignment: .leading, spacing: 16) {
                    if !episodes.isEmpty {
                        Text("Episodes:")
                            .font(.headline)
                            .padding(.top, 8)
                        
                        EpisodesListView(episodes: episodes)
                    } else {
                        DetailRow(
                            title: "Not found",
                            value: " at any episode"
                        )
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.cyan.opacity(0.4))
                        .innerRoundedBorder(color: .indigo, lineWidth: 4, cornerRadius: 12)
                )
            }
        }
        .padding()
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.inline)
        .alert("Error",
               isPresented: Binding<Bool>(
                   get: { episodesError != nil },
                   set: { if !$0 { episodesError = nil } }
               ),
               actions: {
                   Button("OK") { episodesError = nil }
               },
               message: {
                   Text(episodesError ?? "")
               })
        .task {
            if episodes.isEmpty {
                let ids: [Int] = character.episode
                    .compactMap { URL(string: $0)?.lastPathComponent }
                    .compactMap(Int.init)
                do {
                    episodes = try await episodeRepo.episodes(ids: ids)
                } catch {
                    episodesError = error.localizedDescription
                }
            }
        }
    }
}
