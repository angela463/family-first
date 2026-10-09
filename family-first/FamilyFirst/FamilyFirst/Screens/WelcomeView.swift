import SwiftUI

struct WelcomeView: View {
    var onParent: () -> Void
    var onChild: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topLeading) {
                Theme.mint
                VStack(spacing: 18) {
                    HStack(spacing: 8) {
                        Image(systemName: "heart")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Theme.mint)
                            .frame(width: 34, height: 34)
                            .background(Theme.forest, in: RoundedRectangle(cornerRadius: 11, style: .continuous))
                        Text(Copy.Welcome.brand)
                            .themeFont(.cardTitle)
                            .foregroundStyle(Theme.forest)
                    }
                    .padding(.top, 64)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer(minLength: 0)
                    ZStack {
                        Circle()
                            .fill(Theme.mintStrong)
                            .overlay { Circle().stroke(Theme.white, lineWidth: 8) }
                        FamilyMark()
                    }
                    .frame(width: Theme.Space.welcomeCircle, height: Theme.Space.welcomeCircle)
                }
                .padding(.horizontal, Theme.Space.screen)
                .padding(.bottom, 32)
            }
            .frame(height: Theme.Space.welcomeHeaderHeight)
            .clipShape(BottomRoundedRectangle(radius: Theme.Space.welcomeHeaderRadius))

            VStack(alignment: .leading, spacing: 14) {
                Text(Copy.Welcome.headline)
                    .themeFont(.welcomeHeadline)
                    .foregroundStyle(Theme.forest)
                    .fixedSize(horizontal: false, vertical: true)
                Text(Copy.Welcome.body)
                    .themeFont(.body)
                    .foregroundStyle(Theme.inkSecondary)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 16)
                PrimaryButton(title: Copy.Welcome.parent, action: onParent)
                SecondaryButton(title: Copy.Welcome.child, action: onChild)
            }
            .padding(.horizontal, 28)
            .padding(.top, 32)
            .padding(.bottom, 40)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .background(Theme.white)
        .ignoresSafeArea(edges: .top)
    }
}

#Preview("Welcome") {
    WelcomeView(onParent: {}, onChild: {})
}
