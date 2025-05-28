//
//  PlaceholderTextField.swift
//  CurlyJoy
//
//  Created by Manuel Pino Ros on 30/4/25.
//
import SwiftUI

struct PlaceholderTextField: View {
    @Binding var text: String
    var placeholder: String
    var placeholderColor: Color = .gray

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(placeholderColor)
                    .padding(.leading, 4) // adjust as needed
            }

            TextField("", text: $text)
                .accessibilityIdentifier("Search")
                .padding(4)
            
        }
    }
}
