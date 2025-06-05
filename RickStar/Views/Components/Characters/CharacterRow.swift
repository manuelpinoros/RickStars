//
//  CharacterRow.swift
//  RickStar
//
//  Created by Manuel Pino Ros on 27/5/25.
//
import SwiftUI
import RickMortyDomain

struct CharacterRow: View {
    
    let rickCharacter: RickCharacter
    let image: UIImage?
    
    public var body: some View {
        HStack {
            VStack {
                if let uiImage = image {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .statusBorderCircle(CharacterStatus(rawValue: rickCharacter.status.lowercased()) ?? .unknown, lineWidth: 4)
                        .padding([.leading, .top], standardPadding)
                } else {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .statusBorderCircle(CharacterStatus(rawValue: rickCharacter.status.lowercased()) ?? .unknown, lineWidth: 4)
                        .padding([.leading, .top], standardPadding)
                }
                Spacer()
            }
            CharacterRowTextData(name: rickCharacter.name,
                                 origin: rickCharacter.origin.name,
                                 species: rickCharacter.species,
                                 lastSeen: rickCharacter.location.name)
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
