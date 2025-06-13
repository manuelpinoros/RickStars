//
//  SearchBarView.swift
//  DesignSystem
//
//  Created by Manuel Pino Ros on 13/6/25.
//
import SwiftUI

public struct SearchBarView: View {
    
    @Binding var searchText: String
    
    public init(searchText: Binding<String>) {
        self._searchText = searchText 
    }
    
    public var body: some View {
        VStack {
            HStack(spacing: Spacing.small) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white)
                
                PlaceholderTextField(text: $searchText, placeholder: "Search", placeholderColor: .white)
                    .foregroundStyle(.white)
            }
            .padding(.vertical, Spacing.small)
            .padding(.horizontal, Spacing.medium)
            .background(
                Capsule()
                    .fill(.mint.opacity(0.4))
                    .overlay(
                        Capsule()
                            .stroke(.cyan, lineWidth: BorderWidth.small)
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
