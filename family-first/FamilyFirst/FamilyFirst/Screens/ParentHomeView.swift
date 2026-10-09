import SwiftUI

struct ParentHomeView: View {
    var parentName: String
    var children: [FamilyChild]
    var onOpenChild: (FamilyChild) -> Void

    private var attention: (count: Int, reason: String, child: FamilyChild)? {
        let needing = children.filter { $0.attentionReason != nil }
        guard let first = needing.first, let reason = first.attentionReason else { return nil }
        return (needing.count, reason, first)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                header
                VStack(alignment: .leading, spacing: Theme.Space.cardGap) {
                    Text(Copy.Home.family)
                        .themeFont(.sectionTitle)
                        .foregroundStyle(Theme.forest)
                        .padding(.top, Theme.Space.screen)
                    ForEach(children) { child in
                        ChildCard(
                            name: child.name,
                            deviceName: child.deviceName,
                            initial: child.initial,
                            avatar: child.avatar,
                            pillTitle: child.pillTitle,
                            pillStyle: child.pillStyle,
                            dots: child.dots,
                            summary: child.summary,
                            summaryNeedsAttention: child.summaryNeedsAttention
                        ) {
                            onOpenChild(child)
                        }
                    }
                    addChild
                }
                .padding(.horizontal, Theme.Space.screen)
                .padding(.bottom, 120)
            }
        }
        .background(Theme.white)
        .ignoresSafeArea(edges: .top)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: Theme.Space.headerGap) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(greeting)
                        .themeFont(.greeting)
                        .foregroundStyle(Theme.inkSecondary)
                    Text(Copy.Home.hello(parentName))
                        .themeFont(.screenTitle)
                        .foregroundStyle(Theme.forest)
                }
                Spacer()
                Text(String(parentName.prefix(1)))
                    .themeFont(.cardTitle)
                    .foregroundStyle(Theme.white)
                    .frame(width: Theme.Space.parentAvatar, height: Theme.Space.parentAvatar)
                    .background(Theme.forest, in: Circle())
                    .overlay { Circle().stroke(Theme.white, lineWidth: 3) }
            }
            if let attention {
                AttentionBanner(
                    title: Copy.Home.needsYou(attention.count),
                    reason: attention.reason,
                    actionTitle: Copy.Home.fix
                ) {
                    onOpenChild(attention.child)
                }
            }
        }
        .padding(.top, 64)
        .padding(.bottom, 28)
        .padding(.horizontal, Theme.Space.screen)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.mint, in: BottomRoundedRectangle(radius: Theme.Space.headerRadius))
    }

    private var addChild: some View {
        HStack(spacing: 8) {
            Image(systemName: "plus")
                .font(.system(size: 16, weight: .semibold))
            Text(Copy.Home.addChild)
                .themeFont(.bodySmall)
                .fontWeight(.heavy)
        }
        .foregroundStyle(Theme.forest)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .overlay {
            RoundedRectangle(cornerRadius: Theme.Space.addChildRadius, style: .continuous)
                .stroke(Theme.forest.opacity(0.45), style: StrokeStyle(lineWidth: Theme.Space.border, dash: [6, 5]))
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Copy.Home.addChild)
    }

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: .now)
        switch hour {
        case 5..<12: return Copy.Home.goodMorning
        case 12..<17: return Copy.Home.goodAfternoon
        default: return Copy.Home.goodEvening
        }
    }
}

#Preview("Parent home") {
    ParentHomeView(parentName: DesignSample.parentName, children: DesignSample.children) { _ in }
}
