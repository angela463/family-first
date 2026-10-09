import SwiftUI

enum FamilyTab: Hashable, CaseIterable {
    case home
    case alerts
    case settings

    var title: String {
        switch self {
        case .home: Copy.Tab.home
        case .alerts: Copy.Tab.alerts
        case .settings: Copy.Tab.settings
        }
    }

    var systemImage: String {
        switch self {
        case .home: "house"
        case .alerts: "bell"
        case .settings: "gearshape"
        }
    }
}

struct FloatingTabBar: View {
    @Binding var selection: FamilyTab

    var body: some View {
        HStack(spacing: 4) {
            ForEach(FamilyTab.allCases, id: \.self) { tab in
                Button {
                    selection = tab
                } label: {
                    VStack(spacing: 2) {
                        Image(systemName: tab.systemImage)
                            .font(.system(size: 20, weight: .semibold))
                        Text(tab.title)
                            .themeFont(.tabLabel)
                    }
                    .foregroundStyle(selection == tab ? Theme.forest : Theme.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(selection == tab ? Theme.mint : Color.clear, in: RoundedRectangle(cornerRadius: Theme.Space.tabPillRadius, style: .continuous))
                }
                .buttonStyle(.plain)
                .frame(minHeight: Theme.Space.minTouch)
                .accessibilityLabel(tab.title)
                .accessibilityAddTraits(selection == tab ? .isSelected : [])
            }
        }
        .padding(8)
        .background(Theme.forest, in: RoundedRectangle(cornerRadius: Theme.Space.tabBarRadius, style: .continuous))
        .padding(.horizontal, Theme.Space.tabBarSide)
        .padding(.bottom, Theme.Space.tabBarBottom)
    }
}

#Preview("Tab bar") {
    @Previewable @State var tab = FamilyTab.home
    ZStack(alignment: .bottom) {
        Theme.white
        FloatingTabBar(selection: $tab)
    }
}
