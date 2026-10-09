# Family First — Design Spec (v1)

This is the source of truth for the app's look and navigation. The HTML files in
`design/screens/` are the reference mockups (390 × 844, iPhone). Read them for
exact layout, spacing and copy. They are **reference only**. Do not ship them or
embed them in a web view. Rebuild every screen natively in SwiftUI.

## Goals

- Warm and family-focused, not technical.
- **Fewest possible taps.** Anything a parent needs is at most 2 taps from Home.
- Plain language everywhere. Never show reason codes, owner IDs, or spec
  identifiers in the parent or child experience.

## Hard rules from the product spec (do not break)

1. **No single "protected" badge or combined status.** Each of the 7
   capabilities is always shown with its own status.
2. **Alerts are content-free.** They say what changed (stopped, interrupted,
   restored) and when. Never show category, severity, or any content.
3. **Notification permission is requested only after the user asks for
   alerts.** Never at launch.
4. **The Developer view stays out of production builds.** Keep it behind
   `#if DEBUG` and remove it from the main tab bar.
5. **Don't change the logic.** Session states, the safety pipeline, alert
   triggers and the research-model isolation stay exactly as they are. This
   work is presentation only.
6. All user-facing copy here is **draft** and awaits safeguarding and legal
   review. Keep strings in one place (a `Copy.swift` or `Localizable.strings`)
   so they're easy to replace.

## Design tokens

Create `Theme.swift` holding these. Never hard-code hex values in views.

### Colors

| Token | Hex | Use |
|---|---|---|
| `forest` | `#1E4D3A` | Primary: buttons, headings, tab bar, "on" status |
| `forestDark` | `#143628` | Pressed state |
| `mint` | `#DDF3E8` | Header backgrounds, selected tab, soft fills |
| `mintStrong` | `#BFE8D3` | Illustration circle, accents |
| `mintSurface` | `#F4FAF6` | Card inner rows, "on" row background |
| `white` | `#FFFFFF` | Screen background |
| `ink` | `#1F2D26` | Body text |
| `inkSecondary` | `#4A5C53` | Secondary text |
| `inkMuted` | `#55665D` | Captions, timestamps |
| `border` | `#E2EEE7` | Card borders |
| `attention` | `#8A5A00` | "Needs you" text and icons |
| `attentionBg` | `#FFF6E5` | "Needs you" row background |
| `attentionDot` | `#E0A126` | "Needs you" status dot |
| `neutral` | `#3E4A44` | Paused/off icons |
| `neutralBg` | `#F3F5F4` | Paused row background |
| `neutralDot` | `#C3CCC7` | Off / not-yet status dot |

### Typography

Use the system rounded font: `.fontDesign(.rounded)` (SF Pro Rounded). It needs
no setup and matches the mockups' Nunito closely.

| Style | Size | Weight |
|---|---|---|
| Screen title | 30 | heavy |
| Welcome headline | 32 | heavy |
| Section title | 18 | heavy |
| Card title | 16–18 | heavy |
| Body | 15–16 | regular |
| Caption | 13 | semibold |
| Section label (ALL CAPS, 0.6 tracking) | 13 | heavy |
| Tab label | 12 | bold |

Support Dynamic Type: use scaled sizes, not fixed ones.

### Shape and spacing

- Screen side padding: 24 (20 on Child detail).
- Card corner radius: 20–24. Small icon tiles: 12–14. Pills and primary
  buttons: fully rounded (capsule).
- Header panels: mint background with 32 pt rounded **bottom** corners only.
- Card border: 1.5 pt `border`. No drop shadows.
- Gaps: 10–14 between cards, 14–18 inside headers.
- Minimum touch target: 44 × 44.

### Icons

Use SF Symbols, outline style, in `forest` (or white on `forest`):
house, bell, gearshape, checkmark, pause, stop (square), exclamationmark.triangle,
link, lock, shield, shield.checkered, chevron.left, chevron.right, plus.

## Components

- **PrimaryButton**: capsule, `forest` fill, white heavy text 17–18, 18–20 pt
  vertical padding, full width.
- **SecondaryButton**: capsule, white fill, 2 pt `forest` border, `forest` text.
- **StatusPill**: capsule, 13 bold. "Session on" = `forest` with white text.
  "Paused" = `neutralBg` with `neutral` text.
- **ChildCard**: avatar (56, initial on a soft tint, later a photo), name, device
  name, StatusPill. Below that, a `mintSurface` row holding **7 dots** (10 pt,
  one per capability, colored by status) and a short summary ("3 of 7 on ·
  Details" or "1 needs you · Details"). The whole card taps through to Child
  detail.
- **AttentionBanner**: white card inside the mint header. Warning icon tile,
  "1 thing needs you" plus a one-line reason, and a compact "Fix" button. Hide
  it when nothing needs attention.
- **CapabilityRow**: icon tile, title, one-line plain-language status, and an
  action button only when the parent can act (e.g. "Reconnect").
- **FloatingTabBar**: `forest` capsule-ish bar (radius 28), 16 pt from the
  sides, 24 pt from the bottom, 3 equal tabs. The selected tab gets a `mint`
  pill with `forest` icon and text; the others are white.

## Navigation

```
Welcome
 ├─ "I'm a parent" ──────────► Parent tabs: [Home] [Alerts] [Settings]
 │                               Home → Child detail (push)
 │                               Alerts → Child detail (push)
 └─ "This is my child's phone" ► Child session (single screen, no tab bar)
```

The Welcome choice is remembered. Don't show it again after the first launch.

## Screens

### 1. Welcome (`screens/Welcome.dc.html`)
- Top ~470 pt: mint panel, 48 pt rounded bottom corners. Logo (heart in a
  `forest` rounded square) plus "Family First" at the top left.
- Centered: 300 pt circle, `mintStrong` fill, 8 pt white border, with the
  three-person family illustration in `forest` (use the inline SVG from the
  HTML file, converted to a SwiftUI `Shape` or a PDF/SVG asset).
- Headline "Peace of mind for the whole family". Body: "See exactly what's
  keeping your kids safe online, and know right away if anything changes."
- Bottom: PrimaryButton "I'm a parent", SecondaryButton "This is my child's
  phone".

### 2. Parent home (`screens/Main.dc.html`)
- Mint header: "Good afternoon" (changes with time of day) plus "Hi, [name]",
  avatar at the right, and an AttentionBanner when something needs the parent.
- "Your family" title, one ChildCard per child, then a dashed "+ Add a child"
  card.
- FloatingTabBar with Home selected.

### 3. Child detail (`screens/Coverage.dc.html`)
- Mint header: back button (44 pt white circle), avatar 64, name, "[device] ·
  checked [time] ago".
- The 7 capabilities grouped into sections, in this order, and a section is
  hidden when empty:
  **NEEDS YOU** (`attentionBg` rows with an action) → **ON** (`mintSurface`
  rows, `forest` check tile) → **PAUSED** (`neutralBg` rows) → **NOT AVAILABLE
  YET** (one compact bordered list: label left, reason right).

Map each capability to its plain-language name:

| Spec capability | Label | Example statuses |
|---|---|---|
| session | Protection session | On since 3:12 PM / Paused at 3:40 PM / Off |
| content visibility | Screen content | Needs Apple approval |
| analysis readiness | Safety check | Ready on Leo's iPad |
| preview safety | Image previews | Coming soon |
| provider connection | Connected apps | Sign-in expired → **Reconnect** |
| guardian delivery | Alerts to your phone | Coming soon |
| safety state | Safety status | Not known yet |

Map each underlying state to its group: available/ready → ON. Action needed
from the parent → NEEDS YOU. User-paused → PAUSED. Unsupported, unavailable or
unknown → NOT AVAILABLE YET. Keep that mapping in one function so it's easy to
review.

### 4. Alerts (`screens/Alerts.dc.html`)
- Title "Alerts". A mint info strip with a lock icon: "Alerts tell you when
  protection changes, never what your child was doing."
- Grouped by day (TODAY, YESTERDAY). Each row: icon tile, a one-line event
  ("Leo paused protection", "Maya's protection is back on", "Maya's protection
  was interrupted", "Leo stopped protection"), "[device] · [time]", and a
  chevron. Tapping it opens that child's detail. Interrupted rows use the
  attention colors.
- FloatingTabBar with Alerts selected.

### 5. Child session (`screens/ChildSession.dc.html`)
- Top left: avatar plus "Hey there" / "[child name]".
- Center: 240 pt ring with a 176 pt core. Active = `mint` ring and `forest`
  core with a white shield-check. Not active = `neutralBg` ring and white core
  with a `forest` shield outline.
- Headline and a one-line explanation (balanced line wrapping, no orphans):
  - Ready: "Ready when you are" / "Tap start to turn on protection for this
    phone." → PrimaryButton "Start protection"
  - Active: "Protection is on" / "Started at [time]. You can pause any time." →
    two buttons side by side: "Pause" (mint fill) and "Stop" (outlined)
  - Paused: "Protection is paused" / "Paused at [time]. Your grown-up has been
    told." → "Resume protection"
  - Stopped: "Protection is off" / "Stopped at [time]. Your grown-up has been
    told." → "Start again"
- Footer caption: "Your grown-up gets a note if protection stops. They never
  see your messages."
- Drive this entirely from the existing session state machine. Transitional
  states show their real state, never a pretend "on".

## Sample data (for previews only)
Parent "Sam". Children: Maya (Maya's iPhone, session on, 3 of 7 on) and Leo
(Leo's iPad, paused, Connected apps needs reconnecting). Put these in SwiftUI
`#Preview` blocks only. The real app uses real data.
