//
//  CharacterRow.swift
//  RickStar
//
//  Created by Manuel Pino Ros on 27/5/25.
//
import SwiftUI
import RickMortyDomain
import CacheKit

struct CharacterRow: View {
    
    let character: Character
    let cache: ImageCache
    
    public var body: some View {
        HStack {
            CachedAsyncImage(url: character.image, cache: cache) {
                Image(systemName: "person.crop.circle")
                    .frame(width: 100, height: 100)
            }
            .frame(width: 100, height: 100)
            .statusBorderCircle(CharacterStatus(rawValue: character.status.lowercased()) ?? .unknown, lineWidth: 4)
            
            CharacterRowTextData(name: character.name,
                                 origin: character.origin.name,
                                 species: character.species,
                                 lastSeen: character.location.name)
            
            .padding(.leading, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.cyan.opacity(0.4)))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.indigo, lineWidth: 2)
        )
        .padding(.vertical, 4)
    }
}
