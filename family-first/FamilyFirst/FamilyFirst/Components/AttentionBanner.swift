import SwiftUI

struct AttentionBanner: View {
    var title: String
    var reason: String
    var actionTitle: String
    var action: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Theme.attention)
                .frame(width: Theme.Space.iconTile, height: Theme.Space.iconTile)
                .background(Theme.attentionBg, in: RoundedRectangle(cornerRadius: Theme.Space.iconTileRadius, style: .continuous))
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .themeFont(.bodySmall)
                    .fontWeight(.heavy)
                    .foregroundStyle(Theme.ink)
                Text(reason)
                    .themeFont(.caption)
                    .foregroundStyle(Theme.inkMuted)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            PrimaryButton(title: actionTitle, compact: true, action: action)
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 16)
        .background(Theme.white, in: RoundedRectangle(cornerRadius: Theme.Space.rowRadius, style: .continuous))
    }
}

#Preview("Attention banner") {
    AttentionBanner(
        title: Copy.Home.needsYou(1),
        reason: "Leo's apps need reconnecting",
        actionTitle: Copy.Home.fix
    ) {}
    .padding(Theme.Space.screen)
    .background(Theme.mint)
}
