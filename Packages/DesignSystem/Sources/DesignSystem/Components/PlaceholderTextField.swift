//
//  PlaceholderTextField.swift
//  DesignSystem
//
//  Created by Manuel Pino Ros on 13/6/25.
//
import SwiftUI

struct PlaceholderTextField: View {
    @Binding var text: String
    var placeholder: String
    var placeholderColor: Color = .gray
    var accIdentifier: String = "Search"
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(placeholderColor)
                    .padding(.leading, Spacing.small)
            }

            TextField("", text: $text)
                .accessibilityIdentifier(accIdentifier)
                .padding(Spacing.small)
            
        }
    }
}
