//
//  CustomButton.swift
//  CurlyJoy
//
//  Created by Manuel Pino Ros on 9/4/25.
//
import SwiftUI

// Create a custom button style to handle the pressed state
struct CustomButtonStyle: ButtonStyle {
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
                RoundedRectangle(cornerRadius: standardRadius)
                    .fill(configuration.isPressed ? selectedColor : backgroundColor)
            }
            
            // The label (icon or text) from the button
            configuration.label
        }
        .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct CustomButton: View {
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
    
    var body: some View {
        buttonWithProperShape()
    }
    
    @ViewBuilder
    private func buttonWithProperShape() -> some View {
        if buttonShape == .circle {
            buttonContent()
                .contentShape(Circle())
        } else {
            buttonContent()
                .contentShape(RoundedRectangle(cornerRadius: 8))
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
                    RoundedRectangle(cornerRadius: standardRadius)
                        .fill(backgroundColor)
                        .overlay(
                            RoundedRectangle(cornerRadius: standardRadius)
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
        .buttonStyle(CustomButtonStyle(backgroundColor: backgroundColor,
                                       selectedColor: selectedColor,
                                       buttonShape: buttonShape))
        .frame(width: size, height: size)
    }
}
