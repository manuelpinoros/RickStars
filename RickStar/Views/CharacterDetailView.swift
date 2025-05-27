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
        VStack(spacing: 16) {
            AsyncImage(url: character.image) { phase in
                switch phase {
                case .success(let img): img.resizable()
                default: ProgressView()
                }
            }
            .frame(width: 160, height: 160)
            .clipShape(Circle())

            Text(character.name).font(.largeTitle).bold()
            HStack {
                Text(NSLocalizedString("detail.status", comment: ""))
                Text(character.status)
            }
            Spacer()
        }
        .padding()
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
