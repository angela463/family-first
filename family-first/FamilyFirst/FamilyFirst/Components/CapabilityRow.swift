import SwiftUI

struct CapabilityRow: View {
    enum Style {
        case needsYou
        case on
        case paused
    }

    var title: String
    var status: String
    var systemImage: String
    var style: Style
    var actionTitle: String?
    var action: (() -> Void)?

    var body: some View {
        HStack(spacing: 12) {
            icon
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .themeFont(.cardTitleSmall)
                    .foregroundStyle(Theme.ink)
                Text(status)
                    .themeFont(.caption)
                    .foregroundStyle(statusColor)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            if let actionTitle, let action {
                PrimaryButton(title: actionTitle, compact: true, action: action)
            }
        }
        .padding(14)
        .background(background, in: RoundedRectangle(cornerRadius: Theme.Space.rowRadius, style: .continuous))
    }

    private var icon: some View {
        Image(systemName: systemImage)
            .font(.system(size: 18, weight: .semibold))
            .foregroundStyle(iconColor)
            .frame(width: Theme.Space.iconTile, height: Theme.Space.iconTile)
            .background(iconBackground, in: RoundedRectangle(cornerRadius: Theme.Space.iconTileRadius, style: .continuous))
    }

    private var background: Color {
        switch style {
        case .needsYou: Theme.attentionBg
        case .on: Theme.mintSurface
        case .paused: Theme.neutralBg
        }
    }

    private var iconBackground: Color {
        style == .on ? Theme.forest : Theme.white
    }

    private var iconColor: Color {
        switch style {
        case .needsYou: Theme.attention
        case .on: Theme.white
        case .paused: Theme.neutral
        }
    }

    private var statusColor: Color {
        switch style {
        case .needsYou: Theme.attention
        case .on: Theme.inkSecondary
        case .paused: Theme.neutral
        }
    }
}

#Preview("Capability rows") {
    VStack(spacing: Theme.Space.rowGap) {
        CapabilityRow(
            title: Copy.Capability.connectedApps,
            status: Copy.Capability.signInExpired,
            systemImage: "link",
            style: .needsYou,
            actionTitle: Copy.Detail.reconnect
        ) {}
        CapabilityRow(
            title: Copy.Capability.safetyCheck,
            status: Copy.Capability.ready(on: "Leo's iPad"),
            systemImage: "checkmark",
            style: .on
        )
        CapabilityRow(
            title: Copy.Capability.session,
            status: Copy.Capability.paused(on: "Leo's iPad", at: "3:40 PM"),
            systemImage: "pause",
            style: .paused
        )
    }
    .padding(Theme.Space.screen)
    .background(Theme.white)
}
