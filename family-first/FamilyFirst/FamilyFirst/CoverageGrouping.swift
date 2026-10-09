import Foundation

/// How a capability is shown. Available or ready is On. A parent action is
/// Needs you. A user pause is Paused. Unsupported, unavailable, or unknown
/// is Not available yet.
enum CoverageSignal: Equatable {
    case ready
    case needsParent
    case userPaused
    case unavailable
}

enum CoverageGroup: Int, CaseIterable {
    case needsYou
    case on
    case paused
    case unavailable

    var title: String {
        switch self {
        case .needsYou: Copy.Detail.needsYou
        case .on: Copy.Detail.on
        case .paused: Copy.Detail.paused
        case .unavailable: Copy.Detail.notAvailable
        }
    }
}

func coverageGroup(for signal: CoverageSignal) -> CoverageGroup {
    switch signal {
    case .ready: .on
    case .needsParent: .needsYou
    case .userPaused: .paused
    case .unavailable: .unavailable
    }
}
