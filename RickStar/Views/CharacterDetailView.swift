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
                        HStack {
                            Text(NSLocalizedString("Status:", comment: ""))
                                .font(.headline)
                            Spacer()
                            Text(character.status)
                                .font(.subheadline)
                                .multilineTextAlignment(.trailing)
                        }
                        HStack {
                            Text("Species:")
                                .font(.headline)
                            Spacer()
                            Text(character.species)
                                .font(.subheadline)
                                .multilineTextAlignment(.trailing)
                        }
                        HStack {
                            Text("Type:")
                                .font(.headline)
                            Spacer()
                            Text(character.type.isEmpty ? "Unknown" : character.type)
                                .font(.subheadline)
                                .multilineTextAlignment(.trailing)
                        }
                        HStack {
                            Text("Origin:")
                                .font(.headline)
                            Spacer()
                            Text(character.origin.name)
                                .font(.subheadline)
                                .multilineTextAlignment(.trailing)
                        }
                        HStack {
                            Text("Location:")
                                .font(.headline)
                            Spacer()
                            Text(character.location.name)
                                .font(.subheadline)
                                .multilineTextAlignment(.trailing)
                        }
                        HStack {
                            Text("Episodes:")
                                .font(.headline)
                            Spacer()
                            Text("\(character.episode.count)")
                                .font(.subheadline)
                        }
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
