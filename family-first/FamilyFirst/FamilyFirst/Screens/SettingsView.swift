import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(Copy.Settings.title)
                .themeFont(.screenTitle)
                .foregroundStyle(Theme.forest)
            Text(Copy.Settings.body)
                .themeFont(.body)
                .foregroundStyle(Theme.inkSecondary)
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 64)
        .padding(.horizontal, Theme.Space.screen)
        .padding(.bottom, 120)
        .background(Theme.white)
        .ignoresSafeArea(edges: .top)
    }
}

#Preview("Settings") {
    SettingsView()
}
