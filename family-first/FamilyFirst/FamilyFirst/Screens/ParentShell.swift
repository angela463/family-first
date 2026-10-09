import SwiftUI

struct ParentShell: View {
    var initialTab: FamilyTab = .home
    var initialChildID: String? = nil
    @State private var tab: FamilyTab
    @State private var path: [String]

    init(initialTab: FamilyTab = .home, initialChildID: String? = nil) {
        self.initialTab = initialTab
        self.initialChildID = initialChildID
        _tab = State(initialValue: initialTab)
        _path = State(initialValue: initialChildID.map { [$0] } ?? [])
    }

    var body: some View {
        NavigationStack(path: $path) {
            root
                .navigationDestination(for: String.self) { id in
                    if let child = DesignSample.child(id) {
                        ChildDetailView(child: child) { path.removeLast() }
                    }
                }
        }
    }

    private var root: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch tab {
                case .home:
                    ParentHomeView(parentName: DesignSample.parentName, children: DesignSample.children) { child in
                        path.append(child.id)
                    }
                case .alerts:
                    AlertsView(notices: DesignSample.notices) { child in
                        path.append(child.id)
                    }
                case .settings:
                    SettingsView()
                }
            }
            if path.isEmpty {
                FloatingTabBar(selection: $tab)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview("Parent shell") {
    ParentShell()
}
