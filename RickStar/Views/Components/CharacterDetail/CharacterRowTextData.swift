//
//  CharacterInfoView.swift
//  RickStar
//
//  Created by Manuel Pino Ros on 27/5/25.
//
import SwiftUI

struct CharacterRowTextData: View {
    
    let name: String
    let origin: String
    let species: String
    let lastSeen: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(name.isEmpty ? "Unknown" : name)
                .font(.headline)
                .padding(.top, 8)
            HStack(alignment: .top,spacing: 5){
                Text("Origin:").font(.subheadline)
                Text(origin.isEmpty ? "Unknown" : origin)
                    .font(.subheadline)
                    .lineLimit(2)
                    .truncationMode(.tail)
            }
            
            HStack(spacing: 5){
                Text("Specie:").font(.subheadline)
                Text(species.isEmpty ? "Unknown" : species)
                    .font(.subheadline)
            }
            
            HStack(alignment: .top,spacing: 5){
                Text("Last seen:").font(.subheadline)
                Text(lastSeen.isEmpty ? "Unknown" : lastSeen)
                    .font(.subheadline)
                    .lineLimit(2)
                    .truncationMode(.tail)
            }
            Spacer()
        }
    }
}
