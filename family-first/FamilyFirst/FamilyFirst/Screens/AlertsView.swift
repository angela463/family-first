import SwiftUI

struct AlertsView: View {
    var notices: [ProtectionNotice]
    var onOpenChild: (FamilyChild) -> Void

    private var days: [String] {
        var seen: [String] = []
        for notice in notices where !seen.contains(notice.day) {
            seen.append(notice.day)
        }
        return seen
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text(Copy.Alerts.title)
                    .themeFont(.screenTitle)
                    .foregroundStyle(Theme.forest)
                    .padding(.top, 64)
                HStack(alignment: .center, spacing: 10) {
                    Image(systemName: "lock")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Theme.forest)
                    Text(Copy.Alerts.info)
                        .themeFont(.caption)
                        .foregroundStyle(Theme.forest)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Theme.mint, in: RoundedRectangle(cornerRadius: 16, style: .continuous))

                ForEach(days, id: \.self) { day in
                    Text(day)
                        .themeFont(.sectionLabel)
                        .foregroundStyle(Theme.neutral)
                        .padding(.top, 6)
                    ForEach(notices.filter { $0.day == day }) { notice in
                        row(notice)
                    }
                }
            }
            .padding(.horizontal, Theme.Space.screen)
            .padding(.bottom, 120)
        }
        .background(Theme.white)
        .ignoresSafeArea(edges: .top)
    }

    private func row(_ notice: ProtectionNotice) -> some View {
        Button {
            if let child = DesignSample.child(notice.childID) {
                onOpenChild(child)
            }
        } label: {
            HStack(spacing: 12) {
                Image(systemName: symbol(notice.kind))
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(iconColor(notice.kind))
                    .frame(width: Theme.Space.alertTile, height: Theme.Space.alertTile)
                    .background(tileColor(notice.kind), in: RoundedRectangle(cornerRadius: Theme.Space.alertTileRadius, style: .continuous))
                VStack(alignment: .leading, spacing: 1) {
                    Text(notice.title)
                        .themeFont(.cardTitleSmall)
                        .foregroundStyle(Theme.ink)
                    Text(notice.detail)
                        .themeFont(.caption)
                        .foregroundStyle(Theme.inkMuted)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Theme.inkMuted)
            }
            .padding(14)
            .background(notice.kind == .interrupted ? Theme.attentionBg : Theme.white, in: RoundedRectangle(cornerRadius: Theme.Space.rowRadius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: Theme.Space.rowRadius, style: .continuous)
                    .stroke(notice.kind == .interrupted ? Theme.attentionDot.opacity(0.7) : Theme.border, lineWidth: Theme.Space.border)
            }
        }
        .buttonStyle(.plain)
    }

    private func symbol(_ kind: ProtectionNotice.Kind) -> String {
        switch kind {
        case .paused: "pause"
        case .restored: "checkmark"
        case .interrupted: "exclamationmark.triangle"
        case .stopped: "stop"
        }
    }

    private func tileColor(_ kind: ProtectionNotice.Kind) -> Color {
        switch kind {
        case .paused, .stopped: Theme.neutralBg
        case .restored: Theme.mint
        case .interrupted: Theme.attentionBg
        }
    }

    private func iconColor(_ kind: ProtectionNotice.Kind) -> Color {
        switch kind {
        case .paused, .stopped: Theme.neutral
        case .restored: Theme.forest
        case .interrupted: Theme.attention
        }
    }
}

#Preview("Alerts") {
    AlertsView(notices: DesignSample.notices) { _ in }
}
