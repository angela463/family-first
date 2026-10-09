import SwiftUI

struct ChildDetailView: View {
    var child: FamilyChild
    var onBack: () -> Void

    private var grouped: [(CoverageGroup, [Capability])] {
        CoverageGroup.allCases.compactMap { group in
            let rows = child.capabilities.filter { coverageGroup(for: $0.signal) == group }
            return rows.isEmpty ? nil : (group, rows)
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Space.rowGap) {
                header
                VStack(alignment: .leading, spacing: Theme.Space.rowGap) {
                    ForEach(grouped, id: \.0) { group, rows in
                        section(group: group, rows: rows)
                    }
                }
                .padding(.horizontal, Theme.Space.detailScreen)
                .padding(.bottom, 32)
            }
        }
        .background(Theme.white)
        .ignoresSafeArea(edges: .top)
        .toolbar(.hidden, for: .navigationBar)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 16) {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Theme.forest)
                    .frame(width: Theme.Space.minTouch, height: Theme.Space.minTouch)
                    .background(Theme.white, in: Circle())
            }
            .accessibilityLabel(Copy.Detail.back)
            HStack(spacing: 14) {
                AvatarBadge(initial: child.initial, tint: child.avatar, size: Theme.Space.avatarLarge, ring: true)
                VStack(alignment: .leading, spacing: 2) {
                    Text(child.name)
                        .themeFont(.detailTitle)
                        .foregroundStyle(Theme.forest)
                    Text(Copy.Detail.checked(child.deviceName, child.checkedAgo))
                        .themeFont(.buttonCompact)
                        .foregroundStyle(Theme.inkSecondary)
                }
            }
        }
        .padding(.top, 56)
        .padding(.bottom, 22)
        .padding(.horizontal, Theme.Space.detailScreen)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.mint, in: BottomRoundedRectangle(radius: Theme.Space.headerRadius))
    }

    @ViewBuilder
    private func section(group: CoverageGroup, rows: [Capability]) -> some View {
        Text(group.title)
            .themeFont(.sectionLabel)
            .foregroundStyle(labelColor(group))
            .padding(.top, group == grouped.first?.0 ? 10 : 8)
        if group == .unavailable {
            VStack(spacing: 0) {
                ForEach(Array(rows.enumerated()), id: \.element.id) { index, row in
                    HStack {
                        Text(row.title)
                            .themeFont(.bodySmall)
                            .fontWeight(.heavy)
                            .foregroundStyle(Theme.ink)
                        Spacer(minLength: 12)
                        Text(row.status)
                            .themeFont(.caption)
                            .foregroundStyle(Theme.inkMuted)
                    }
                    .padding(.vertical, 11)
                    if index < rows.count - 1 {
                        Rectangle().fill(Theme.border).frame(height: 1)
                    }
                }
            }
            .padding(.horizontal, 14)
            .overlay {
                RoundedRectangle(cornerRadius: Theme.Space.rowRadius, style: .continuous)
                    .stroke(Theme.border, lineWidth: Theme.Space.border)
            }
        } else {
            ForEach(rows) { row in
                CapabilityRow(
                    title: row.title,
                    status: row.status,
                    systemImage: row.signal == .ready ? "checkmark" : row.systemImage,
                    style: rowStyle(group),
                    actionTitle: row.actionTitle,
                    action: row.actionTitle == nil ? nil : {}
                )
            }
        }
    }

    private func labelColor(_ group: CoverageGroup) -> Color {
        switch group {
        case .needsYou: Theme.attention
        case .on: Theme.forest
        case .paused, .unavailable: Theme.neutral
        }
    }

    private func rowStyle(_ group: CoverageGroup) -> CapabilityRow.Style {
        switch group {
        case .needsYou: .needsYou
        case .on: .on
        case .paused, .unavailable: .paused
        }
    }
}

#Preview("Child detail") {
    ChildDetailView(child: DesignSample.leo, onBack: {})
}
