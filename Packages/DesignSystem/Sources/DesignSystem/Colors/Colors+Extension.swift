import SwiftUI

public final class DesignSystemBundle {}

public extension Color {
    static let accentPrimary = Color("AccentPrimary", bundle: .module)
    static let backgroundPrimary = Color("BackgroundPrimary", bundle: .module)
    static let backgroundControlsPrimary = Color("BackgroundControlsPrimary", bundle: .module)
    static let fontColorPrimary = Color("FontColorPrimary", bundle: .module)
    static let iconColorPrimary = Color("IconColorPrimary", bundle: .module)
}
