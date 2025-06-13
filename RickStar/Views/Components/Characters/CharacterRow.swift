//
//  CharacterRow.swift
//  RickStar
//
//  Created by Manuel Pino Ros on 27/5/25.
//
import SwiftUI
import RickMortyDomain
import DesignSystem

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
                        .padding([.leading, .top], Spacing.medium)
                } else {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .statusBorderCircle(CharacterStatus(rawValue: rickCharacter.status.lowercased()) ?? .unknown, lineWidth: 4)
                        .padding([.leading, .top], Spacing.medium)
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
        .padding(Spacing.medium)
        .background(
            RoundedRectangle(cornerRadius: Radius.medium)
                .fill(Color.mint.opacity(0.3))
                .innerRoundedBorder(color: .cyan,
                                    lineWidth: BorderWidth.small,
                                    cornerRadius: Radius.medium)
        )
        .padding(.vertical, 4)
    }
}
