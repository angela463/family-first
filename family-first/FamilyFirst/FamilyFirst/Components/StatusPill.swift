import SwiftUI

struct StatusPill: View {
    enum Style {
        case on
        case paused
    }

    var title: String
    var style: Style

    var body: some View {
        Text(title)
            .themeFont(.caption)
            .foregroundStyle(style == .on ? Theme.white : Theme.neutral)
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background(style == .on ? Theme.forest : Theme.neutralBg, in: Capsule())
    }
}

#Preview("Status pill") {
    HStack {
        StatusPill(title: Copy.Home.sessionOn, style: .on)
        StatusPill(title: Copy.Home.paused, style: .paused)
    }
    .padding()
    .background(Theme.white)
}
