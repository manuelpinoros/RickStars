//
//  CharacterDetailView.swift
//  RickStar
//
//  Created by Manuel Pino Ros on 27/5/25.
//
import SwiftUI
import RickMortyDomain

struct CharacterDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var vm: CharacterDetailViewModel
    @State private var episodesErrorMessage: String?
    
    init(rickCharacter: RickCharacter) {
        _vm = State(wrappedValue: CharacterDetailViewModel(rickCharacter: rickCharacter))
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            AsyncImage(url: vm.rickCharacter.image) { phase in
                switch phase {
                case .success(let img): img.resizable()
                default: ProgressView()
                }
            }
            .frame(width: 160, height: 160)
            .clipShape(Circle())
            .statusBorderCircle(CharacterStatus(rawValue: vm.rickCharacter.status.lowercased()) ?? .unknown,
                                lineWidth: 4)
            .frame(maxWidth: .infinity)
            
            ScrollView(.vertical, showsIndicators: false) {
                CharacterDetailTextData(name: vm.rickCharacter.name,
                                        status: vm.rickCharacter.status,
                                        specie: vm.rickCharacter.species,
                                        typeRM: vm.rickCharacter.type,
                                        originRM: vm.rickCharacter.origin.name,
                                        lastSeen: vm.rickCharacter.location.name,
                                        appearIn: vm.episodes.count)
                
                VStack(alignment: .leading, spacing: 16) {
                    if !vm.episodes.isEmpty {
                        Text("Episodes:")
                            .font(.headline)
                            .padding(.top, standardPadding)
                        
                        EpisodesList(episodes: vm.episodes)
                    } else {
                        DetailRow(
                            title: "Not found".localized,
                            value: " at any episode".localized
                        )
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.mint.opacity(0.3))
                        .innerRoundedBorder(color: .cyan, lineWidth: 4, cornerRadius: 12)
                )
            }
        }
        .detailNavigationStyle(title: vm.rickCharacter.name,
                              dismissAction: dismiss)
        .task {
            do {
                try await vm.loadEpisodes()
            } catch {
                episodesErrorMessage = error.localizedDescription
            }
        }
        .alert("Error",
               isPresented: Binding<Bool>(
                   get: { episodesErrorMessage != nil },
                   set: { if !$0 { episodesErrorMessage = nil } }
               ),
               actions: {
                   Button("OK") { episodesErrorMessage = nil }
               },
               message: {
                   Text(episodesErrorMessage ?? "")
               })
    }
}
