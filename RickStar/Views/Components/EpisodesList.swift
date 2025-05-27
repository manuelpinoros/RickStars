//
//  EpisodesListView.swift
//  RickStar
//
//  Created by Manuel Pino Ros on 27/5/25.
//
import SwiftUI
import RickMortyData
import RickMortyDomain

struct EpisodesList: View {
    
    let episodes: [Episode]

    var body: some View {
        LazyVStack(alignment: .leading, spacing: 0) {
            ForEach(episodes) { ep in
                VStack(alignment: .leading, spacing: 4) {
                    Text(ep.code)
                        .font(.headline)
                    Text(ep.name)
                        .font(.subheadline)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 8)

                if ep.id != episodes.last?.id {
                    Rectangle()
                        .fill(Color.indigo)
                        .frame(height: 2)
                }
            }
        }
    }
}
