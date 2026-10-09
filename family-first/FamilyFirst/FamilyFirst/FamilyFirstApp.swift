import SwiftUI

enum HouseholdRole: String {
    case parent
    case child
}

enum DesignLaunch {
    static var screen: String? {
        let arguments = CommandLine.arguments
        guard let index = arguments.firstIndex(of: "-designScreen"), index + 1 < arguments.count else { return nil }
        return arguments[index + 1]
    }
}

struct RootView: View {
    @AppStorage("familyFirst.role") private var role = ""

    var body: some View {
        switch DesignLaunch.screen {
        case "welcome":
            welcome
        case "home":
            ParentShell()
        case "detail":
            ParentShell(initialChildID: DesignSample.leo.id)
        case "alerts":
            ParentShell(initialTab: .alerts)
        case "session":
            ChildSessionView(child: DesignSample.maya)
        default:
            stored
        }
    }

    @ViewBuilder
    private var stored: some View {
        switch HouseholdRole(rawValue: role) {
        case .parent:
            ParentShell()
        case .child:
            ChildSessionView(child: DesignSample.maya)
        case nil:
            welcome
        }
    }

    private var welcome: some View {
        WelcomeView {
            role = HouseholdRole.parent.rawValue
        } onChild: {
            role = HouseholdRole.child.rawValue
        }
    }
}

@main
struct FamilyFirstApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .tint(Theme.forest)
        }
    }
}
