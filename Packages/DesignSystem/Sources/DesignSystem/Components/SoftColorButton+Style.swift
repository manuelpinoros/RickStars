//
//  SoftColorButtonStyle.swift
//  DesignSystem
//
//  Created by Manuel Pino Ros on 13/6/25.
//
import SwiftUI

public enum ButtonShape{
    case circle
    case rounded
}

struct SoftColorButtonStyle: ButtonStyle {
    var backgroundColor: Color
    var selectedColor: Color
    var buttonShape: ButtonShape
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            // Background with dynamic color based on press state
            if buttonShape == .circle {
                Circle()
                    .fill(configuration.isPressed ? selectedColor : backgroundColor)
            } else {
                RoundedRectangle(cornerRadius: Radius.small)
                    .fill(configuration.isPressed ? selectedColor : backgroundColor)
            }
            
            // The label (icon or text) from the button
            configuration.label
        }
        .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

public struct SoftColorButton: View {
    var size: CGFloat = 48
    var backgroundColor: Color = .white
    var selectedColor: Color = .red
    var iconColor: Color = .red
    var icon: String? = nil
    var title: String? = nil
    var action: () -> Void = { print("action") }
    var buttonShape: ButtonShape = .circle
    var borderColor: Color? = nil
    var borderWidth: CGFloat = 0
    
    public var body: some View {
        buttonWithProperShape()
    }
    
    public init(size: CGFloat = 48,
                backgroundColor: Color = .white,
                selectedColor: Color = .red,
                iconColor: Color = .red,
                icon: String? = nil,
                title: String? = nil,
                action: @escaping () -> Void = { print("action") },
                buttonShape: ButtonShape = .circle,
                borderColor: Color? = nil,
                borderWidth: CGFloat = 0) {
        self.size = size
        self.backgroundColor = backgroundColor
        self.selectedColor = selectedColor
        self.iconColor = iconColor
        self.icon = icon
        self.title = title
        self.action = action
        self.buttonShape = buttonShape
        self.borderColor = borderColor
        self.borderWidth = borderWidth
    }
    
    @ViewBuilder
    private func buttonWithProperShape() -> some View {
        if buttonShape == .circle {
            buttonContent()
                .contentShape(Circle())
        } else {
            buttonContent()
                .contentShape(RoundedRectangle(cornerRadius: Radius.small))
        }
    }
    
    private func buttonContent() -> some View {
        Button(action: {
            action()
        }) {
            ZStack {
                // Background
                if buttonShape == .circle {
                    Circle()
                        .fill( backgroundColor)
                        .overlay(
                            Circle()
                                .strokeBorder(borderColor ?? .clear, lineWidth: borderWidth)
                        )
                }
                else {
                    RoundedRectangle(cornerRadius: Radius.small)
                        .fill(backgroundColor)
                        .overlay(
                            RoundedRectangle(cornerRadius: Radius.small)
                                .strokeBorder(borderColor ?? .clear, lineWidth: borderWidth)
                        )
                }
                
                // Icon or text
                if let icon = icon {
                    Image(systemName: icon, fallbackAssetName: icon)
                        .font(.system(size: size / 2))
                        .foregroundColor(iconColor)
                } else {
                    Text(title ?? "button")
                        .foregroundColor(iconColor)
                }
            }
        }
        .buttonStyle(SoftColorButtonStyle(backgroundColor: backgroundColor,
                                          selectedColor: selectedColor,
                                          buttonShape: buttonShape))
        .frame(width: size, height: size)
    }
}

extension Image {
    init(systemName: String, fallbackAssetName: String) {
        if let _ = UIImage(systemName: systemName) {
            self = Image(systemName: systemName)
                .renderingMode(.template)
        } else {
            self = Image(fallbackAssetName)
                .renderingMode(.template)
        }
    }
}
