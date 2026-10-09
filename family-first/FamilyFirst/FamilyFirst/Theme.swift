import SwiftUI
import UIKit

/// Design tokens from DESIGN.md. Views take color, type, and spacing from here.
enum Theme {
    static let forest = Color(hex: 0x1E4D3A)
    static let forestDark = Color(hex: 0x143628)
    static let mint = Color(hex: 0xDDF3E8)
    static let mintStrong = Color(hex: 0xBFE8D3)
    static let mintSurface = Color(hex: 0xF4FAF6)
    static let white = Color(hex: 0xFFFFFF)
    static let ink = Color(hex: 0x1F2D26)
    static let inkSecondary = Color(hex: 0x4A5C53)
    static let inkMuted = Color(hex: 0x55665D)
    static let border = Color(hex: 0xE2EEE7)
    static let attention = Color(hex: 0x8A5A00)
    static let attentionBg = Color(hex: 0xFFF6E5)
    static let attentionDot = Color(hex: 0xE0A126)
    static let neutral = Color(hex: 0x3E4A44)
    static let neutralBg = Color(hex: 0xF3F5F4)
    static let neutralDot = Color(hex: 0xC3CCC7)

    /// Soft avatar tints from the mockups. They are not in the DESIGN.md table.
    static let avatarWarm = Color(hex: 0xF6D8C8)
    static let avatarWarmInk = Color(hex: 0x7A3E1F)
    static let avatarCool = Color(hex: 0xCFE3F5)
    static let avatarCoolInk = Color(hex: 0x234A6B)

    enum Space {
        static let screen: CGFloat = 24
        static let detailScreen: CGFloat = 20
        static let cardRadius: CGFloat = 24
        static let rowRadius: CGFloat = 20
        static let addChildRadius: CGFloat = 20
        static let iconTile: CGFloat = 40
        static let iconTileRadius: CGFloat = 12
        static let alertTile: CGFloat = 44
        static let alertTileRadius: CGFloat = 14
        static let headerRadius: CGFloat = 32
        static let welcomeHeaderRadius: CGFloat = 48
        static let welcomeHeaderHeight: CGFloat = 470
        static let tabBarRadius: CGFloat = 28
        static let tabPillRadius: CGFloat = 22
        static let border: CGFloat = 1.5
        static let cardGap: CGFloat = 14
        static let rowGap: CGFloat = 10
        static let headerGap: CGFloat = 18
        static let minTouch: CGFloat = 44
        static let tabBarSide: CGFloat = 16
        static let tabBarBottom: CGFloat = 24
        static let dot: CGFloat = 10
        static let avatar: CGFloat = 56
        static let avatarLarge: CGFloat = 64
        static let avatarSession: CGFloat = 48
        static let parentAvatar: CGFloat = 52
        static let welcomeCircle: CGFloat = 300
        static let sessionRing: CGFloat = 240
        static let sessionCore: CGFloat = 176
        static let buttonPadding: CGFloat = 18
        static let buttonPaddingLarge: CGFloat = 20
    }

    enum AvatarTint {
        case warm
        case cool

        var background: Color {
            switch self {
            case .warm: Theme.avatarWarm
            case .cool: Theme.avatarCool
            }
        }

        var foreground: Color {
            switch self {
            case .warm: Theme.avatarWarmInk
            case .cool: Theme.avatarCoolInk
            }
        }
    }

    enum Dot {
        case on
        case attention
        case off

        var color: Color {
            switch self {
            case .on: Theme.forest
            case .attention: Theme.attentionDot
            case .off: Theme.neutralDot
            }
        }
    }

    enum TextRole {
        case screenTitle
        case welcomeHeadline
        case detailTitle
        case sectionTitle
        case cardTitle
        case cardTitleSmall
        case body
        case bodySmall
        case greeting
        case caption
        case sectionLabel
        case tabLabel
        case button
        case buttonLarge
        case buttonCompact
        case sessionName

        var size: CGFloat {
            switch self {
            case .screenTitle: 30
            case .welcomeHeadline: 32
            case .detailTitle: 28
            case .sectionTitle, .cardTitle: 18
            case .cardTitleSmall, .body: 16
            case .bodySmall, .greeting: 15
            case .caption, .sectionLabel: 13
            case .tabLabel: 12
            case .button: 17
            case .buttonLarge: 18
            case .buttonCompact: 14
            case .sessionName: 22
            }
        }

        var weight: Font.Weight {
            switch self {
            case .body, .bodySmall: .regular
            case .caption, .greeting: .semibold
            case .tabLabel: .bold
            default: .heavy
            }
        }

        var relativeTo: Font.TextStyle {
            switch self {
            case .screenTitle, .welcomeHeadline, .detailTitle: .largeTitle
            case .sectionTitle, .cardTitle, .sessionName: .title3
            case .cardTitleSmall, .body, .button, .buttonLarge: .body
            case .bodySmall, .greeting: .subheadline
            case .caption, .sectionLabel, .buttonCompact: .footnote
            case .tabLabel: .caption
            }
        }

        var tracking: CGFloat {
            self == .sectionLabel ? 0.6 : 0
        }

        var uppercase: Bool {
            self == .sectionLabel
        }
    }

    static func scaledFont(size: CGFloat, weight: Font.Weight, relativeTo style: Font.TextStyle) -> Font {
        let uiWeight = weight.uiWeight
        let base = UIFont.systemFont(ofSize: size, weight: uiWeight)
        let rounded = base.fontDescriptor.withDesign(.rounded) ?? base.fontDescriptor
        let font = UIFont(descriptor: rounded, size: size)
        let scaled = UIFontMetrics(forTextStyle: style.uiTextStyle).scaledFont(for: font)
        return Font(scaled)
    }
}

struct ThemeFont: ViewModifier {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    let role: Theme.TextRole

    func body(content: Content) -> some View {
        let _ = dynamicTypeSize
        content
            .font(Theme.scaledFont(size: role.size, weight: role.weight, relativeTo: role.relativeTo))
            .tracking(role.tracking)
            .textCase(role.uppercase ? .uppercase : nil)
    }
}

extension View {
    func themeFont(_ role: Theme.TextRole) -> some View {
        modifier(ThemeFont(role: role))
    }
}

struct BottomRoundedRectangle: Shape {
    var radius: CGFloat

    func path(in rect: CGRect) -> Path {
        let radius = min(radius, min(rect.width, rect.height) / 2)
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - radius))
        path.addArc(
            center: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius),
            radius: radius,
            startAngle: .degrees(0),
            endAngle: .degrees(90),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: rect.minX + radius, y: rect.maxY))
        path.addArc(
            center: CGPoint(x: rect.minX + radius, y: rect.maxY - radius),
            radius: radius,
            startAngle: .degrees(90),
            endAngle: .degrees(180),
            clockwise: false
        )
        path.closeSubpath()
        return path
    }
}

private extension Color {
    init(hex: UInt32) {
        let red = Double((hex >> 16) & 0xFF) / 255
        let green = Double((hex >> 8) & 0xFF) / 255
        let blue = Double(hex & 0xFF) / 255
        self.init(red: red, green: green, blue: blue)
    }
}

private extension Font.Weight {
    var uiWeight: UIFont.Weight {
        switch self {
        case .heavy: .heavy
        case .bold: .bold
        case .semibold: .semibold
        case .regular: .regular
        default: .regular
        }
    }
}

private extension Font.TextStyle {
    var uiTextStyle: UIFont.TextStyle {
        switch self {
        case .largeTitle: .largeTitle
        case .title: .title1
        case .title2: .title2
        case .title3: .title3
        case .headline: .headline
        case .body: .body
        case .callout: .callout
        case .subheadline: .subheadline
        case .footnote: .footnote
        case .caption: .caption1
        case .caption2: .caption2
        default: .body
        }
    }
}
