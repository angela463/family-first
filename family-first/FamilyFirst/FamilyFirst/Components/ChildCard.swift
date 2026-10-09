import SwiftUI

struct ChildCard: View {
    var name: String
    var deviceName: String
    var initial: String
    var avatar: Theme.AvatarTint
    var pillTitle: String
    var pillStyle: StatusPill.Style
    var dots: [Theme.Dot]
    var summary: String
    var summaryNeedsAttention: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 14) {
                    AvatarBadge(initial: initial, tint: avatar, size: Theme.Space.avatar)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(name)
                            .themeFont(.cardTitle)
                            .foregroundStyle(Theme.ink)
                        Text(deviceName)
                            .themeFont(.caption)
                            .foregroundStyle(Theme.inkMuted)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    StatusPill(title: pillTitle, style: pillStyle)
                }
                HStack {
                    HStack(spacing: 5) {
                        ForEach(Array(dots.enumerated()), id: \.offset) { _, dot in
                            Circle()
                                .fill(dot.color)
                                .frame(width: Theme.Space.dot, height: Theme.Space.dot)
                        }
                    }
                    Spacer(minLength: 8)
                    Text(summary)
                        .themeFont(.caption)
                        .foregroundStyle(summaryNeedsAttention ? Theme.attention : Theme.inkSecondary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Theme.mintSurface, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .padding(16)
            .background(Theme.white, in: RoundedRectangle(cornerRadius: Theme.Space.cardRadius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: Theme.Space.cardRadius, style: .continuous)
                    .stroke(Theme.border, lineWidth: Theme.Space.border)
            }
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(name), \(deviceName), \(pillTitle), \(summary)")
    }
}

struct AvatarBadge: View {
    var initial: String
    var tint: Theme.AvatarTint
    var size: CGFloat
    var ring = false

    var body: some View {
        Text(initial)
            .themeFont(size >= Theme.Space.avatarLarge ? .detailTitle : .cardTitle)
            .foregroundStyle(tint.foreground)
            .frame(width: size, height: size)
            .background(tint.background, in: Circle())
            .overlay {
                if ring {
                    Circle().stroke(Theme.white, lineWidth: 3)
                }
            }
    }
}

#Preview("Child cards") {
    VStack(spacing: Theme.Space.cardGap) {
        ChildCard(
            name: "Maya",
            deviceName: "Maya's iPhone",
            initial: "M",
            avatar: .warm,
            pillTitle: Copy.Home.sessionOn,
            pillStyle: .on,
            dots: Array(repeating: .on, count: 3) + Array(repeating: .off, count: 4),
            summary: Copy.Home.onSummary(3),
            summaryNeedsAttention: false
        ) {}
        ChildCard(
            name: "Leo",
            deviceName: "Leo's iPad",
            initial: "L",
            avatar: .cool,
            pillTitle: Copy.Home.paused,
            pillStyle: .paused,
            dots: [.on, .attention] + Array(repeating: .off, count: 5),
            summary: Copy.Home.needsSummary(1),
            summaryNeedsAttention: true
        ) {}
    }
    .padding(Theme.Space.screen)
    .background(Theme.white)
}
