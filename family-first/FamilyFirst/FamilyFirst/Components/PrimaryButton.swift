import SwiftUI

struct PrimaryButton: View {
    enum Fill {
        case forest
        case mint
    }

    var title: String
    var fill: Fill = .forest
    var compact = false
    var large = false
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .themeFont(compact ? .buttonCompact : (large ? .buttonLarge : .button))
                .foregroundStyle(fill == .forest ? Theme.white : Theme.forest)
                .padding(.vertical, compact ? 12 : (large ? Theme.Space.buttonPaddingLarge : Theme.Space.buttonPadding))
                .padding(.horizontal, compact ? 16 : 18)
                .frame(maxWidth: compact ? nil : .infinity)
                .frame(minHeight: compact ? Theme.Space.minTouch : nil)
        }
        .buttonStyle(PrimaryButtonStyle(fill: fill))
        .accessibilityLabel(title)
    }
}

private struct PrimaryButtonStyle: ButtonStyle {
    var fill: PrimaryButton.Fill

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(background(pressed: configuration.isPressed), in: Capsule())
    }

    private func background(pressed: Bool) -> Color {
        switch fill {
        case .forest:
            pressed ? Theme.forestDark : Theme.forest
        case .mint:
            pressed ? Theme.mintStrong : Theme.mint
        }
    }
}

#Preview("Primary") {
    VStack(spacing: 12) {
        PrimaryButton(title: Copy.Welcome.parent) {}
        PrimaryButton(title: Copy.Session.start, large: true) {}
        PrimaryButton(title: Copy.Session.pause, fill: .mint) {}
        PrimaryButton(title: Copy.Home.fix, compact: true) {}
    }
    .padding(Theme.Space.screen)
    .background(Theme.white)
}
