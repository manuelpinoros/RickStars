//
//  CharacterRow.swift
//  RickStar
//
//  Created by Manuel Pino Ros on 27/5/25.
//
import SwiftUI
import RickMortyDomain

struct CharacterRow: View {
    
    let character: Character
    let image: UIImage?
    
    public var body: some View {
        HStack {
            VStack {
                if let uiImage = image {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .statusBorderCircle(CharacterStatus(rawValue: character.status.lowercased()) ?? .unknown, lineWidth: 4)
                        .padding([.leading, .top], standardPadding)
                } else {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .statusBorderCircle(CharacterStatus(rawValue: character.status.lowercased()) ?? .unknown, lineWidth: 4)
                        .padding([.leading, .top], standardPadding)
                }
                Spacer()
            }
            CharacterRowTextData(name: character.name,
                                 origin: character.origin.name,
                                 species: character.species,
                                 lastSeen: character.location.name)
                .padding(.leading, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(standardPadding)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.mint.opacity(0.3)))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.cyan, lineWidth: 4)
        )
        .padding(.vertical, 4)
    }
}
