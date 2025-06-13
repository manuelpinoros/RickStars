//
//  ViewModifiers.swift
//  DesignSystem
//
//  Created by Manuel Pino Ros on 13/6/25.
//
import SwiftUI

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
    public func roundedBorder(color: Color = .black, lineWidth: CGFloat = 1, cornerRadius: CGFloat = Radius.small) -> some View {
        self.modifier(RoundedBorderModifier(color: color, lineWidth: lineWidth, cornerRadius: cornerRadius))
    }
    
    public func innerRoundedBorder(color: Color = .black, lineWidth: CGFloat = 1, cornerRadius: CGFloat = Radius.small) -> some View {
        self.modifier(InnerRoundedBorderModifier(color: color, lineWidth: lineWidth, cornerRadius: cornerRadius))
    }
}
