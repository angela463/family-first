import Foundation

/// Draft parent and child wording from DESIGN.md. Safeguarding and legal review
/// still have to approve every string before it is treated as final.
enum Copy {
    enum Welcome {
        static let brand = "Family First"
        static let headline = "Peace of mind for the whole family"
        static let body = "See exactly what's keeping your kids safe online, and know right away if anything changes."
        static let parent = "I'm a parent"
        static let child = "This is my child's phone"
    }

    enum Home {
        static let goodMorning = "Good morning"
        static let goodAfternoon = "Good afternoon"
        static let goodEvening = "Good evening"
        static func hello(_ name: String) -> String { "Hi, \(name)" }
        static func needsYou(_ count: Int) -> String {
            count == 1 ? "1 thing needs you" : "\(count) things need you"
        }
        static let family = "Your family"
        static let addChild = "Add a child"
        static let sessionOn = "Session on"
        static let paused = "Paused"
        static func onSummary(_ count: Int) -> String { "\(count) of 7 on · Details" }
        static func needsSummary(_ count: Int) -> String {
            count == 1 ? "1 needs you · Details" : "\(count) need you · Details"
        }
        static let fix = "Fix"
    }

    enum Detail {
        static let back = "Back"
        static func checked(_ device: String, _ when: String) -> String { "\(device) · checked \(when)" }
        static let needsYou = "Needs you"
        static let on = "On"
        static let paused = "Paused"
        static let notAvailable = "Not available yet"
        static let reconnect = "Reconnect"
    }

    enum Capability {
        static let session = "Protection session"
        static let screenContent = "Screen content"
        static let safetyCheck = "Safety check"
        static let imagePreviews = "Image previews"
        static let connectedApps = "Connected apps"
        static let alertsToPhone = "Alerts to your phone"
        static let safetyStatus = "Safety status"
        static let signInExpired = "Sign-in expired"
        static func ready(on device: String) -> String { "Ready on \(device)" }
        static func paused(on device: String, at time: String) -> String { "Paused on \(device) at \(time)" }
        static let needsAppleApproval = "Needs Apple approval"
        static let comingSoon = "Coming soon"
        static let notKnownYet = "Not known yet"
    }

    enum Alerts {
        static let title = "Alerts"
        static let info = "Alerts tell you when protection changes, never what your child was doing."
        static let today = "Today"
        static let yesterday = "Yesterday"
    }

    enum Session {
        static let hey = "Hey there"
        static let readyTitle = "Ready when you are"
        static let readyBody = "Tap start to turn on protection for this phone."
        static let start = "Start protection"
        static let activeTitle = "Protection is on"
        static func activeBody(started: String) -> String { "Started at \(started). You can pause any time." }
        static let pause = "Pause"
        static let stop = "Stop"
        static let pausedTitle = "Protection is paused"
        static func pausedBody(at time: String) -> String { "Paused at \(time). Your grown-up has been told." }
        static let resume = "Resume protection"
        static let stoppedTitle = "Protection is off"
        static func stoppedBody(at time: String) -> String { "Stopped at \(time). Your grown-up has been told." }
        static let startAgain = "Start again"
        static let footer = "Your grown-up gets a note if protection stops. They never see your messages."
    }

    enum Tab {
        static let home = "Home"
        static let alerts = "Alerts"
        static let settings = "Settings"
    }

    enum Settings {
        static let title = "Settings"
        static let body = "Notification choices and account details will live here."
    }
}
