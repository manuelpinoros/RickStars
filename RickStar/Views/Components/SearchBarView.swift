//
//  SearchBarView.swift
//  EscapeSounds
//
//  Created by Manuel Pino Ros on 23/1/25.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String
    
    var body: some View {
        VStack {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white)
                
                PlaceholderTextField(text: $searchText, placeholder: "Search", placeholderColor: .white)
                    .foregroundStyle(.white)
            }
            .padding(.vertical, 7)
            .padding(.horizontal, 14)
            .background(
                Capsule()
                    .fill(.indigo.opacity(0.7))
                    .overlay(
                        Capsule()
                            .stroke(.white, lineWidth: 4)
                    )
            )
            .padding(.horizontal)
        }
       // .padding([.leading, .vertical])
        .visualEffect { content, proxy in
            content.offset(y: offsetY(proxy))
        }
    }
    
    nonisolated private
    func offsetY(_ proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
        return minY > 0 ? 0 : -minY
    }
}

#Preview {
    @Previewable @State var text: String = ""
    SearchBarView(searchText: $text)
}
