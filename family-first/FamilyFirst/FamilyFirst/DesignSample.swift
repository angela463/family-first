import Foundation

/// Sample family from DESIGN.md, used by previews and this design app.
/// The production coverage snapshot and session reducer are not in this repo.
struct Capability: Identifiable, Equatable {
    let id: String
    let title: String
    let status: String
    let systemImage: String
    let signal: CoverageSignal
    var actionTitle: String?
}

struct FamilyChild: Identifiable, Equatable {
    let id: String
    let name: String
    let deviceName: String
    let initial: String
    let avatar: Theme.AvatarTint
    let pillTitle: String
    let pillStyle: StatusPill.Style
    let dots: [Theme.Dot]
    let summary: String
    let summaryNeedsAttention: Bool
    let checkedAgo: String
    let capabilities: [Capability]
    let attentionReason: String?
}

struct ProtectionNotice: Identifiable, Equatable {
    enum Kind {
        case paused
        case restored
        case interrupted
        case stopped
    }

    let id: String
    let childID: String
    let title: String
    let detail: String
    let day: String
    let kind: Kind
}

enum DesignSample {
    static let parentName = "Sam"

    static let maya = FamilyChild(
        id: "maya",
        name: "Maya",
        deviceName: "Maya's iPhone",
        initial: "M",
        avatar: .warm,
        pillTitle: Copy.Home.sessionOn,
        pillStyle: .on,
        dots: Array(repeating: .on, count: 3) + Array(repeating: .off, count: 4),
        summary: Copy.Home.onSummary(3),
        summaryNeedsAttention: false,
        checkedAgo: "1 min ago",
        capabilities: [
            Capability(id: "session", title: Copy.Capability.session, status: "On since 3:12 PM", systemImage: "checkmark", signal: .ready),
            Capability(id: "content", title: Copy.Capability.screenContent, status: "On", systemImage: "checkmark", signal: .ready),
            Capability(id: "analysis", title: Copy.Capability.safetyCheck, status: Copy.Capability.ready(on: "Maya's iPhone"), systemImage: "checkmark", signal: .ready),
            Capability(id: "preview", title: Copy.Capability.imagePreviews, status: Copy.Capability.comingSoon, systemImage: "photo", signal: .unavailable),
            Capability(id: "provider", title: Copy.Capability.connectedApps, status: Copy.Capability.comingSoon, systemImage: "link", signal: .unavailable),
            Capability(id: "delivery", title: Copy.Capability.alertsToPhone, status: Copy.Capability.comingSoon, systemImage: "bell", signal: .unavailable),
            Capability(id: "safety", title: Copy.Capability.safetyStatus, status: Copy.Capability.notKnownYet, systemImage: "shield", signal: .unavailable)
        ],
        attentionReason: nil
    )

    static let leo = FamilyChild(
        id: "leo",
        name: "Leo",
        deviceName: "Leo's iPad",
        initial: "L",
        avatar: .cool,
        pillTitle: Copy.Home.paused,
        pillStyle: .paused,
        dots: [.on, .attention] + Array(repeating: .off, count: 5),
        summary: Copy.Home.needsSummary(1),
        summaryNeedsAttention: true,
        checkedAgo: "2 min ago",
        capabilities: [
            Capability(id: "provider", title: Copy.Capability.connectedApps, status: Copy.Capability.signInExpired, systemImage: "link", signal: .needsParent, actionTitle: Copy.Detail.reconnect),
            Capability(id: "analysis", title: Copy.Capability.safetyCheck, status: Copy.Capability.ready(on: "Leo's iPad"), systemImage: "checkmark", signal: .ready),
            Capability(id: "session", title: Copy.Capability.session, status: Copy.Capability.paused(on: "Leo's iPad", at: "3:40 PM"), systemImage: "pause", signal: .userPaused),
            Capability(id: "content", title: Copy.Capability.screenContent, status: Copy.Capability.needsAppleApproval, systemImage: "iphone", signal: .unavailable),
            Capability(id: "preview", title: Copy.Capability.imagePreviews, status: Copy.Capability.comingSoon, systemImage: "photo", signal: .unavailable),
            Capability(id: "delivery", title: Copy.Capability.alertsToPhone, status: Copy.Capability.comingSoon, systemImage: "bell", signal: .unavailable),
            Capability(id: "safety", title: Copy.Capability.safetyStatus, status: Copy.Capability.notKnownYet, systemImage: "shield", signal: .unavailable)
        ],
        attentionReason: "Leo's apps need reconnecting"
    )

    static let children = [maya, leo]

    static var attentionCount: Int {
        children.filter { $0.attentionReason != nil }.count
    }

    static func child(_ id: String) -> FamilyChild? {
        children.first { $0.id == id }
    }

    static let notices = [
        ProtectionNotice(id: "1", childID: "leo", title: "Leo paused protection", detail: "Leo's iPad · 3:40 PM", day: Copy.Alerts.today, kind: .paused),
        ProtectionNotice(id: "2", childID: "maya", title: "Maya's protection is back on", detail: "Maya's iPhone · 1:12 PM", day: Copy.Alerts.today, kind: .restored),
        ProtectionNotice(id: "3", childID: "maya", title: "Maya's protection was interrupted", detail: "Maya's iPhone · 12:58 PM", day: Copy.Alerts.today, kind: .interrupted),
        ProtectionNotice(id: "4", childID: "leo", title: "Leo stopped protection", detail: "Leo's iPad · 8:05 PM", day: Copy.Alerts.yesterday, kind: .stopped)
    ]
}

enum SessionPresentation: Equatable {
    case ready
    case active
    case paused
    case stopped

    var isActive: Bool { self == .active }
}
