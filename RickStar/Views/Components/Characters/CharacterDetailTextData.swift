//
//  CharacterDetailTextDataç.swift
//  RickStar
//
//  Created by Manuel Pino Ros on 27/5/25.
//
import SwiftUI
import DesignSystem

struct CharacterDetailTextData: View {
    
    let name: String
    let status: String
    let specie: String
    let typeRM: String
    let originRM: String
    let lastSeen: String
    let appearIn: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(name)
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .center)
            
                DetailRow(
                    title: "Status:".localized,
                    value: status
                )
                DetailRow(
                    title: "Specie:".localized,
                    value: specie.isEmpty ? "Unknown".localized : specie
                )
                DetailRow(
                    title: "Type:".localized,
                    value: typeRM.isEmpty ? "Unknown".localized : typeRM
                )
                DetailRow(
                    title: "Origin:".localized,
                    value: originRM.isEmpty ? "Unknown".localized : originRM
                )
                DetailRow(
                    title: "Last seen:".localized,
                    value: lastSeen.isEmpty ? "Unknown".localized : lastSeen
                )
                DetailRow(
                    title: "Appear in:".localized,
                    value: "\(appearIn) " + "episodes".localized
                )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: Radius.medium)
                .fill(Color.mint.opacity(0.3))
                .innerRoundedBorder(color: .cyan,
                                    lineWidth: BorderWidth.small,
                                    cornerRadius: Radius.medium)
        )
    }
}
