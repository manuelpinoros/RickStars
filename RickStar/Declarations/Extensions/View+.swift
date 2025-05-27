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
