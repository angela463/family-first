import SwiftUI

struct SecondaryButton: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .themeFont(.button)
                .foregroundStyle(Theme.forest)
                .padding(.vertical, 16)
                .padding(.horizontal, 18)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(SecondaryButtonStyle())
        .accessibilityLabel(title)
    }
}

private struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Theme.white, in: Capsule())
            .overlay {
                Capsule()
                    .stroke(configuration.isPressed ? Theme.forestDark : Theme.forest, lineWidth: 2)
            }
    }
}

#Preview("Secondary") {
    VStack(spacing: 12) {
        SecondaryButton(title: Copy.Welcome.child) {}
        SecondaryButton(title: Copy.Session.stop) {}
    }
    .padding(Theme.Space.screen)
    .background(Theme.white)
}
