import SwiftUI

struct ChildSessionView: View {
    var child: FamilyChild
    @State private var presentation: SessionPresentation

    init(child: FamilyChild, presentation: SessionPresentation = .ready) {
        self.child = child
        _presentation = State(initialValue: presentation)
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                AvatarBadge(initial: child.initial, tint: child.avatar, size: Theme.Space.avatarSession)
                VStack(alignment: .leading, spacing: 0) {
                    Text(Copy.Session.hey)
                        .themeFont(.buttonCompact)
                        .foregroundStyle(Theme.inkMuted)
                    Text(child.name)
                        .themeFont(.sessionName)
                        .foregroundStyle(Theme.forest)
                }
                Spacer()
            }
            .padding(.top, 64)
            .padding(.horizontal, Theme.Space.screen)

            Spacer(minLength: 0)
            VStack(spacing: 22) {
                ZStack {
                    Circle()
                        .fill(presentation.isActive ? Theme.mint : Theme.neutralBg)
                        .frame(width: Theme.Space.sessionRing, height: Theme.Space.sessionRing)
                    Circle()
                        .fill(presentation.isActive ? Theme.forest : Theme.white)
                        .frame(width: Theme.Space.sessionCore, height: Theme.Space.sessionCore)
                    Image(systemName: presentation.isActive ? "checkmark.shield" : "shield")
                        .font(.system(size: 64, weight: .light))
                        .foregroundStyle(presentation.isActive ? Theme.white : Theme.forest)
                }
                VStack(spacing: 6) {
                    Text(headline)
                        .themeFont(.detailTitle)
                        .foregroundStyle(Theme.forest)
                        .multilineTextAlignment(.center)
                    Text(detail)
                        .themeFont(.bodySmall)
                        .foregroundStyle(Theme.inkSecondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 300)
                }
            }
            .padding(.horizontal, Theme.Space.screen)
            Spacer(minLength: 0)

            VStack(spacing: 12) {
                controls
                Text(Copy.Session.footer)
                    .themeFont(.caption)
                    .foregroundStyle(Theme.inkMuted)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, Theme.Space.screen)
            .padding(.bottom, 48)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.white)
        .ignoresSafeArea(edges: .top)
    }

    @ViewBuilder
    private var controls: some View {
        switch presentation {
        case .ready:
            PrimaryButton(title: Copy.Session.start, large: true) { presentation = .active }
        case .active:
            HStack(spacing: 12) {
                PrimaryButton(title: Copy.Session.pause, fill: .mint) { presentation = .paused }
                SecondaryButton(title: Copy.Session.stop) { presentation = .stopped }
            }
        case .paused:
            PrimaryButton(title: Copy.Session.resume, large: true) { presentation = .ready }
        case .stopped:
            PrimaryButton(title: Copy.Session.startAgain, large: true) { presentation = .ready }
        }
    }

    private var headline: String {
        switch presentation {
        case .ready: Copy.Session.readyTitle
        case .active: Copy.Session.activeTitle
        case .paused: Copy.Session.pausedTitle
        case .stopped: Copy.Session.stoppedTitle
        }
    }

    private var detail: String {
        switch presentation {
        case .ready: Copy.Session.readyBody
        case .active: Copy.Session.activeBody(started: "3:12 PM")
        case .paused: Copy.Session.pausedBody(at: "3:40 PM")
        case .stopped: Copy.Session.stoppedBody(at: "3:41 PM")
        }
    }
}

#Preview("Child session") {
    ChildSessionView(child: DesignSample.maya)
}
