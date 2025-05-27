//
//  CharacterDetailView.swift
//  RickStar
//
//  Created by Manuel Pino Ros on 27/5/25.
//
import SwiftUI
import RickMortyDomain

struct CharacterDetailView: View {
    let character: Character
    
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
                            value: "\(character.episode.count)"
                        )
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.cyan.opacity(0.4))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.indigo, lineWidth: 2)
            )
        }
        .padding()
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
