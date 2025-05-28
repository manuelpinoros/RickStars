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
    func roundedBorder(color: Color = .black, lineWidth: CGFloat = 1, cornerRadius: CGFloat = standardRadius) -> some View {
        self.modifier(RoundedBorderModifier(color: color, lineWidth: lineWidth, cornerRadius: cornerRadius))
    }
    
    func innerRoundedBorder(color: Color = .black, lineWidth: CGFloat = 1, cornerRadius: CGFloat = standardRadius) -> some View {
        self.modifier(InnerRoundedBorderModifier(color: color, lineWidth: lineWidth, cornerRadius: cornerRadius))
    }
}


//MARK: CharacterList modifier
private struct CharacterListStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .listStyle(.plain)
            .accessibilityIdentifier("CharactersList")
            .scrollIndicators(.hidden)
            .scrollContentBackground(.hidden)
            .navigationTitle(NSLocalizedString("RickStar", comment: ""))
    }
}

extension View {
    func characterListStyle() -> some View {
        modifier(CharacterListStyle())
    }
}

//MARK: CharacterDetail modifier
private struct DetailNavigationStyle: ViewModifier {
    let title: String
    let dismissAction: DismissAction

    func body(content: Content) -> some View {
        content
            .padding()
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismissAction() }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.backward")
                            Text("Back")
                        }
                    }
                }
            }
    }
}

extension View {
    func detailNavigationStyle(title: String,
                               dismissAction: DismissAction) -> some View {
        modifier(DetailNavigationStyle(title: title,
                                       dismissAction: dismissAction))
    }
}
