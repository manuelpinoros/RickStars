//
//  View+.swift
//  RickStar
//
//  Created by Manuel Pino Ros on 27/5/25.
//
import SwiftUI
import Foundation


//MARK: Circular character status color border
struct StatusBorderCircle: ViewModifier {
    let status: CharacterStatus
    let lineWidth: CGFloat

    func body(content: Content) -> some View {
        content
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(status.statusColor, lineWidth: lineWidth)
            )
    }
}

extension View {
    func statusBorderCircle(_ status: CharacterStatus, lineWidth: CGFloat = 4) -> some View {
        modifier(StatusBorderCircle(status: status, lineWidth: lineWidth))
    }
}

//MARK: Borders
struct RoundedBorderModifier: ViewModifier {
    var color: Color
    var lineWidth: CGFloat
    var cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(color, lineWidth: lineWidth)
            )
    }
}

struct InnerRoundedBorderModifier: ViewModifier {
    var color: Color
    var lineWidth: CGFloat
    var cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(color, lineWidth: lineWidth)
            )
    }
}

extension View {
    func roundedBorder(color: Color = .black, lineWidth: CGFloat = 1, cornerRadius: CGFloat = 8) -> some View {
        self.modifier(RoundedBorderModifier(color: color, lineWidth: lineWidth, cornerRadius: cornerRadius))
    }
    
    func innerRoundedBorder(color: Color = .black, lineWidth: CGFloat = 1, cornerRadius: CGFloat = 8) -> some View {
        self.modifier(InnerRoundedBorderModifier(color: color, lineWidth: lineWidth, cornerRadius: cornerRadius))
    }
}
