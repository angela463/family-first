---
cursor:
  subagentId: "bc-1df694ec-868d-5e98-aa9a-37b225d8744f"
---

# Family First — ship status

Assessment date: 2026-09-15.  
Authoritative sources: `specs/` under AGENTS.md §9.1 (invariants, accepted ADRs and platform capabilities, requirements and schemas, then task packets). Chat history and `HANDOFF.md` are lowest precedence.  
Spec revision used for this report: `b4cfcf24d684196dda12920c4ef3ef8f43329ccf0a151fba10ca349feca15a08`. Observed: `python3 scripts/spec_revision.py` and `specs/SPEC_REVISION` match; check C13 reports `b4cfcf24d684` over 87 files.

No gate G0–G9 is claimed in this report.

---

## 1. Where the program is

### Program identity and phase

Covenant Eyes Family-First Digital Safety (Family First) is a 12-week feasibility and harm-reduction prototype on iOS. Observed: `specs/product.md` §1 records four week-12 outcomes (proceed Apple-first, proceed with bounded protection, proceed narrowly, stop or redesign). The same section states that no result from the 12-week program authorizes a family beta using live-minor communications. Commercial launch, public beta, and marketing claims are non-goals (`specs/product.md` §3).

Observed: `programPhase: week0-spec-baseline` in `specs/decision-scorecard.yaml`, `specs/open-decisions.yaml`, `specs/tenant-classes.yaml`, and `specs/verification-lanes.yaml`. The 12-week clock is specified to wait on named human preconditions (`specs/open-decisions.yaml` preconditions block, plan section 11.1). P01–P03 are `answered`. P04–P08 are `unanswered`.

### Spec revision and mechanical baseline (this session)

Observed on this Linux host, 2026-09-15:

| Lane | Command | Result |
|---|---|---|
| spec-integrity | `make verify-specs` | PASS, 20 checks (C01–C20) |
| contracts | `make test-contracts` | PASS, 164 tests in 0.027s |
| privacy-static | `make test-privacy` | PASS (same script as verify-specs) |
| security | `make test-security` | PASS secret-scan; SAST, dependency-scan, auth-abuse, rate-limit UNAVAILABLE (owning task CE-CD-001) |
| selftest | `make selftest` | PASS, 15/15 injections caught |

C04: 65 REQ + 16 NFR = 81 requirements. C05: 15 invariants, 62 work-package tasks, 10 gates, 18 decisions, 15 lanes. C09: 29 copy IDs, 0 approved. C10: 1 tenant class, 4 deny rules, 4 classes undefined by design. C11: 13/18 decisions unanswered; 0 gates claimed. C15: 19 allowlist entries, 14 denylist entries, no collisions. C19: 12 emitted scorecards scanned; none claims a gate; none declares `device-verified` (P06 unanswered).

### Gates G0–G9

Observed: `specs/decision-scorecard.yaml` header and `currentState` record `gatesPassed: []` and `gatesClaimable: []`. Every gate has `status: pending`. Check C11 refuses a `pass` while a listed decision is unanswered. Check C13 refuses a `pass` whose evidence comes from a lane that lists the gate in `cannotSatisfyGates`.

| Gate | Name | Spec status | Blocked by unanswered decisions | Satisfying lane named in spec |
|---|---|---|---|---|
| G0 | Product authority and harm | pending | D01, D02, D10, D13 | none (`contributingLanes: []`) |
| G1 | Distribution | pending | D11, D14, D15, D16 | `device-matrix` contributes; P04 unfilled |
| G2 | Capture truth | pending | (none listed) | `device-matrix` only |
| G3 | Data boundary | pending | (none listed) | `privacy-static` plus `device-matrix`; canary half requires hardware |
| G4 | Category validity | pending | D06, D07 | `locked-evaluation` only |
| G5 | Human safety | pending | D05, D06, D10 | none that can close the gate today |
| G6 | Connector value | pending | D08, D14 | none |
| G7 | Security and cryptography | pending | D04, D09 | `security` contributes; independent review required |
| G8 | Operational safety | pending | D02, D03, D10, D12 | none |
| G9 | Final platform regression | pending | (none listed) | `device-matrix` and `locked-evaluation` |

C11 additionally lists G0, G1, G5, G6, G7, G8 as gates with no satisfying lane (human review or external approval required). G1 still lists D14 and D15 in `blockedByDecision` even though those decisions are `answered` in `open-decisions.yaml`. G6 still lists D08 and D14. G7 still lists D04. Observed conflict: answered decisions remain on those `blockedByDecision` lists. C11 still reports 0 gates claimed.

Week-6 gate (`week6Gate.status: pending`) and week-12 gate (`week12Gate.status: pending`) are unset. Observed: `currentlyDelivered` for the week-12 minimum success package is `authority/data contracts (spec-level only)`. `currentlyMissing`: crypto contract implementation, truthful capture state, privacy canaries, prevention baseline, explicit child-side fixture slice.

### Work packages (plan §11.3 registry)

Observed: `specs/work-packages.yaml` `count: 59` and 62 entries. C05 reports 62 tasks. Zero entries have `readiness: done`.

| Readiness | Count | IDs |
|---|---|---|
| ready | 5 | CE-GOV-001, CE-BOOT-001, CE-CONSENT-001, CE-EVD-001, CE-DATA-003 |
| in-progress | 1 | CE-ROUTER-001 |
| registered | 17 | CE-GOV-002, CE-BOOT-002, CE-CD-001, CE-UX-001, CE-ID-001, CE-PAIR-001, CE-AUTH-001, CE-COV-001, CE-CAP-001, CE-CAP-002, CE-DP-001, CE-DET-001, CE-DET-000, CE-GDN-001, CE-DET-003, CE-POLICY-001, CE-CONN-001 |
| blocked | 39 | remainder, including CE-GATE-006, CE-REVIEW-001, CE-RELEASE-001, CE-DECISION-001 |
| done | 0 | — |

24 task packets exist under `specs/tasks/`. 38 work packages have no packet. Packet `readiness` disagrees with the work-package registry for 13 of 24 packets (see §2).

### Tenant and research limits

Observed in `specs/tenant-classes.yaml`:

- Environments in this program: `dev`, `synthetic-staging`, `internal-adult-testflight`. Each lists `tenantClasses: [adultSyntheticFixture]`.
- Only tenant class defined: `adultSyntheticFixture`. `guardianDeliveryEligible: true`. `sourcePixelEligible: conditional` (default deny until REQ-EVD-04). `minorDataPermitted: false`. `liveMinorCommunications: prohibited`.
- Undefined by design: `family`, `minor`, `production`, `consumer`.
- Guardian delivery: `fixtureOnly` in every environment. Source pixels: `prohibited` in `dev`; `fixtureOnlyAfterApproval` in staging and TestFlight.

Invariants (highest precedence):

- INV-RESEARCH-01: guardian delivery is rejected for every tenant except the non-overridable adult/synthetic fixture environment (`specs/invariants.yaml`).
- INV-PRIV-07: source pixels are prohibited for every minor/family tenant, study, or pilot; sanitized crops exist only in approved adult/synthetic fixtures.
- INV-PRIV-04: guardian-visible text is selected from a versioned, counsel-approved fixed-copy catalog. C09: 0 of 29 copy IDs are approved.

Category policies (`specs/category-policies/{explicit-visual,grooming-coercion,sextortion}.yaml`): `releaseState: researchOnly` for all three. `specs/decision-scorecard.yaml` `currentState` records the same, plus `guardianDelivery: blockedTenant` and `sourcePixels: notProduced`.

Evaluation: `specs/evaluation-protocol.md` status is NOT PREREGISTERED / NOT SIGNED. D06 and D07 remain `unanswered`. Safest default: no dataset is authorized; all categories remain `researchOnly`.

D07 landing-zone fetch is pipeline-shape only (`ml/acquire/allowlist.yaml` header). This host has no `/Volumes/Paradeigma/familyfirst-datasets` (observed: path absent). HANDOFF.md dated 2026-08-11 records a complete 16-entry fetch on another machine. C15 now counts 19 allowlist entries. A complete landing zone does not answer D07 (`specs/open-decisions.yaml` D07 `safestDefault`; ADR-0007 status `proposed`).

---

## 2. Done versus remaining, with evidence

### What “done” means here

AGENTS.md §9.6 and `specs/tasks/CE-GOV-001.yaml`: a packet cannot be marked `done` by its implementer unless a named non-implementer reviewer has recorded accept, narrow, or reject. Observed: work-package `readiness: done` count is 0. No checked-in scorecard records a reviewer verdict that closes a gate.

### Task packets

Observed packet `readiness` in `specs/tasks/*.yaml`:

| Packet readiness | Packets |
|---|---|
| ready | CE-AUTH-001, CE-BOOT-001, CE-BOOT-002, CE-CAP-001, CE-CONN-001, CE-CONSENT-001, CE-COV-001, CE-CRYPTO-001, CE-DATA-003, CE-DET-001, CE-DP-001, CE-EVD-001, CE-ID-001, CE-PAIR-001, CE-PRIV-001 |
| in-progress | CE-EVAL-001, CE-GOV-001, CE-GOV-002, CE-ROUTER-001 |
| blocked | CE-DATA-001, CE-DATA-002, CE-PLAT-001, CE-PLAT-004, CE-ROUTER-002 |

Registry conflicts (observed; both files are under `specs/`):

1. CE-PRIV-001 work package deliverable is the seeded D5/D6 canary harness, `readiness: blocked` on P06. The packet with the same ID is DeviceKeyStore, `readiness: ready`. G3’s hardware canary half is owned by the work-package meaning of CE-PRIV-001 (`specs/invariants.yaml` INV-PRIV-01 `enforcementOwner: CE-PRIV-001`; `specs/decision-scorecard.yaml` G3 `partialToday`).
2. CE-CRYPTO-001 packet is `ready`. Work package is `blocked` on D04. D04 is `answered` (single guardian recipient; destructive evidence loss preferred; no CE decrypt).
3. CE-EVAL-001 packet is `in-progress`. Work package is `blocked` on D06/D07. Packet `blockedBy` still states P01–P03 unfilled; `open-decisions.yaml` records P01–P03 `answered`.
4. CE-GOV-001 packet is `in-progress`. Work package is `ready`. Packet `blockedBy` still states P01–P03 unfilled.
5. Twelve other packets are `ready` while the work-package registry is `registered` (CE-AUTH-001, CE-BOOT-002, CE-CAP-001, CE-CONN-001, CE-COV-001, CE-DET-001, CE-DP-001, CE-ID-001, CE-PAIR-001, and the cases above).

HANDOFF.md §7 (lowest precedence) lists many of those IDs as “Implemented (readiness: ready)” and lists no remaining registered packets. The work-package registry records 17 `registered`, 39 `blocked`, and 0 `done`. This report uses the registry and packets. HANDOFF.md is cited only as a dated session log.

### Scorecards

Observed: 12 files under `artifacts/scorecards/CE-*.json`. C19: none has a non-empty `gatesClaimable`; none is `device-verified`. Evidence classes observed: `static-analysis` (11) and `fixture-only` (CE-DET-001). Provenance `specRevision` values on those artifacts are older than `b4cfcf24d684` (historical runs). Valid fixture `tests/fixtures/valid/scorecard.spec-baseline.json` also has `gatesClaimable: []` and a seeded-canary result of UNAVAILABLE.

No scorecard exists for CE-PLAT-001, CE-PRIV-001 canary harness, CE-EVAL-001 locked labels, or CE-GATE-006.

### HANDOFF.md and Final Results (dated, lower precedence)

`HANDOFF.md` header: last updated 2026-08-20; later session headings run through 2026-08-27. Header `Spec revision: cabfe7367413` is stale relative to live `b4cfcf24d684`. The file instructs readers to prefer `docs/results/FamilyFirst_Final_Results.md` (2026-08-13, spec revision `4daffe26…`) where the two disagree.

Observed in Final Results (2026-08-13) and HANDOFF session 2026-08-27: both record **0 of 10 gates claimable** and **no device-verified evidence**. HANDOFF 2026-08-27 records, on a Darwin/Xcode 27 host: `make verify-specs` PASS 20 checks at `b4cfcf24d684`; `make test-contracts` PASS 164; `make test-apple-unit` PASS 142 tests; `make sim-verify` PASS 20 tests; `make build-apple` PASS; `make test-services` PASS 9 Go tests; `make bench` UNAVAILABLE on that host because the dataset volume was unmounted. Those Apple and bench numbers were **not re-measured in this Linux session**. `specs/verification-lanes.yaml` still classifies simulator-ui, apple-unit, and apple-build as unable to satisfy G1, G2, G4, G6, G9 (and related §10.2 gates).

### Verification lanes versus ship

Observed: `specs/verification-lanes.yaml` `programPhase: week0-spec-baseline`. Blocking lanes at this phase: spec-integrity, contracts, privacy-static, security. All four passed on this host today.

UNAVAILABLE lanes named in `currentPhaseSummary`: services, model-development, host-fixture-generation, accessibility, device-matrix, locked-evaluation. `claimableGates: []`.

Stale lane text (observed): `services` `unavailableReason` says `services/` does not exist. This checkout contains `services/connectors/*.go`. This session did not run `make test-services`.

Apple/device lanes this Linux host cannot execute: `build-apple`, `test-apple-unit`, `sim-verify`, `device-plan` (print-only), `bench` (dataset volume absent). Spec: simulator results never satisfy ScreenCaptureKit, Family Controls, URL Filter, background inference, performance, battery, thermal, Keychain/Secure Enclave, or entitlement gates (`specs/platform-capabilities.md`; `verification-lanes.yaml` device-matrix note). All capabilities on `specs/platform-capabilities.md` are `verificationStatus: UNVERIFIED`. P06 note: Xcode 27 / iOS 27 simulators recorded 2026-08-20; one physical iPhone 15 Pro listed unavailable; no device-lab owner.

Security lane is `implementationStatus: partial`: secret-scan only. G7 requires CE-REVIEW-001 independent mobile/backend/crypto/abuse review (`verification-lanes.yaml` security note).

### ADRs

| ADR | Status | Ship effect |
|---|---|---|
| 0001 spec-pack baseline | accepted | Capabilities remain UNVERIFIED until device evidence |
| 0002 protection-session runtime | proposed, blocked on CE-PLAT-001 | Background capture path unset |
| 0003 guardian relay crypto | proposed, blocked on D04 and independent security review | D04 is now answered; independent review still open |
| 0004 latency surrogates | accepted | Bench numbers cannot be accuracy or gate claims |
| 0005 routers are not category models | accepted | Router scorecards stay `gatesClaimable: []` |
| 0006 preregistration thresholds | proposed | D06 remains unanswered as a whole |
| 0007 dataset authorization | proposed | D07 unanswered; P07 unfilled |

---

## 3. Ship blockers

“Ship” in this program is a week-12 executive choice among four outcomes, plus at most `internal-adult-testflight` for adult/synthetic fixtures. A family/minor production ship is out of scope (`specs/product.md` §1; INV-RESEARCH-01).

### Privacy and safety (invariants outrank all other sources)

G3 `partialToday`: closed-schema half is satisfiable now and passes C02/C03/C07. Seeded canary half requires CE-PRIV-001 on hardware and is UNAVAILABLE. The gate needs both.

INV-PRIV-01/02/03 runtime canaries (`test-privacy:seeded-pixel-canary`, `seeded-token-canary`) are UNAVAILABLE. Static deny-lists do not prove emission absence (`verification-lanes.yaml` privacy-static note).

Copy remains draft (C09). CE-INT-001 is blocked on D05. Categories cannot leave `researchOnly` while copy is draft (C09; D05 safest default).

Kill criteria in `specs/decision-scorecard.yaml` (K01–K14) are stop conditions, not scored gates. This session ran static C03/C07/C10/C11/C19 only. Runtime egress (K04 in that file: prohibited content leaves volatile memory) is unmeasured on hardware.

AGENTS.md §2 uses a different K01–K06 numbering for agent-session stop rules. Program kill criteria for ship decisions are the K01–K14 list in `specs/decision-scorecard.yaml`.

### Apple and device UNAVAILABLE lanes

| Blocker | Evidence | Gates held |
|---|---|---|
| P04 Apple Developer Account Holder unanswered | `open-decisions.yaml` | G1; CE-PLAT-002 |
| P06 physical devices and lab owner unanswered | `open-decisions.yaml`; platform-capabilities.md | G2, G9; device-matrix; CE-PRIV-001 canary; CE-PERF-001; CE-PLAT-003 |
| P08 NSScreenCaptureUsageDescription unapproved | `open-decisions.yaml` | G2; ScreenCaptureKit application use |
| All platform capabilities UNVERIFIED | `specs/platform-capabilities.md` | G1, G2, G9 among others |
| Accessibility lane awaiting CE-UX-001 | `verification-lanes.yaml` | G5 contribution |

CE-PLAT-001 remains blocked on CE-PLAT-004, CE-CAP-001, CE-PLAT-002, CE-PRIV-001, P04, P06, and P08 (packet and work package agree).

### Evaluation

CE-EVAL-001 cannot lock category thresholds (steward forbidden; D06). `make test-models` and `make scorecard` (locked-evaluation) are UNAVAILABLE: protocol NOT PREREGISTERED (D06) and no authorized dataset (D07). CE-DET-002, CE-DET-004, CE-DET-005, CE-DATA-002 blocked on D07. CE-DATA-001 blocked until safeguarding-owner fixes the D06-2 severe recall number before the decision set opens. CE-VSLICE-001 blocked on CE-DET-002 and CE-INT-001. Week-6 formal stop/go (CE-GATE-006) blocked on all week-6 prerequisites.

### Legal and human-owned items

Unanswered decisions (13): D01 regions/ages, D02 guardian authority, D03 retention, D05 safety copy, D06 thresholds (D06-2 mechanism only), D07 datasets, D09 backend standard, D10 stop authority / critical-issue definition, D11 entitlement communication, D12 post-week-12 phase, D13 lawful basis, D16 URL Filter/PIR spike, D18 location.

Answered (5): D04 single-recipient crypto, D08 identity-only connectors, D14 device Keychain tokens, D15 monetization (no Screen Time wrapper), D17 child self-protection model.

Unanswered preconditions: P04, P05, P06, P07, P08.

Agents may not approve safety copy, model thresholds, legal basis, provider permitted use, external beta, category promotion beyond `researchOnly`, or ADR acceptance (AGENTS.md §5). CE-REVIEW-001 work package remains `blockedBy: P03 named reviewers` while P03 is `answered` by a single person holding all reviewer roles (`open-decisions.yaml` P03 `answeredBy`). Independent review still sits on the week-12 path.

Work packages still `blockedBy` answered decisions: CE-CONN-000 / CE-CONN-002 / CE-CONN-004 (D08 and/or D14), CE-KEY-001 (D04), CE-CRYPTO-001 / CE-EVD-002 (D04). Registry has not been moved to `ready` after those answers.

---

## 4. Ordered next actions to ship

Order follows blockers and `dependsOn` in `specs/work-packages.yaml` and `specs/open-decisions.yaml`. Calendar estimates are omitted.

1. **Name the remaining preconditions (human).** Fill P04 (Apple Developer Account Holder), P05/D09 (backend standard or recorded prototype fallback), P06 (device lab owner and representative iOS 27 hardware), P07 (adult/synthetic research protocol and dataset custodian), P08 (approved NSScreenCaptureUsageDescription bytes and App Review owner). The 12-week clock is specified to wait on this roster.

2. **Reconcile the work-package registry with answered decisions and packet IDs (spec steward).** Move or split CE-PRIV-001 so the canary harness and DeviceKeyStore are distinct. Update `blockedBy` where D04, D08, D14, and P03 are already `answered`, or record why the package stays blocked. Align `count: 59` with 62 entries. Refresh packet `blockedBy` text that still says P01–P03 unfilled.

3. **Record non-implementer verdicts on in-progress governance packets.** CE-GOV-001, CE-GOV-002, CE-EVAL-001, CE-ROUTER-001 cannot reach `done` without accept/narrow/reject from a reviewer other than the implementer.

4. **Human policy that unlocks product gates.** D01/D02/D10/D13 (G0). D05 approved copy (G5, CE-INT-001). Remaining D06 items signed on `evaluation-protocol.md` (G4/G5; CE-EVAL-001 lock). D07 authorization for each category (G4; ADR-0007 still proposed). D03 retention (G8, CE-LIFE-001, CE-EVD-003). D11 entitlement communications (G1). D16 URL Filter accept or defer (G1; safest default is deferred). D18 keep location unimplemented until answered (G0/G3).

5. **Execute ready, non-device packets that do not promote categories.** CE-DATA-003 (ready in packet and registry) to produce fixture-only evidence with `gatesClaimable: []`. That is the recorded blocker for CE-PLAT-004. Continue CE-ROUTER-001 under ADR-0005 (routers carry `categorySemantics: none`).

6. **ScreenCaptureKit protocol then signed-device capture (after P04/P06/P08 and CE-DATA-003 evidence).** CE-PLAT-004 → CE-CAP-001 → CE-PLAT-001 device-matrix. G2 is specified to be satisfiable only by `device-matrix`. Accept or reject ADR-0002 from that evidence.

7. **Hardware privacy canaries (G3 remainder).** Run the seeded pixel/OCR/token/SCA/credential harness across sandbox files, logs, crash attachments, analytics, clipboard, backups, network, relay, and push on physical devices. Until that lane is PASS, G3 stays pending even with green C02/C03/C07.

8. **Prevention and distribution path (G1).** After P04, file CE-PLAT-002 entitlement register. CE-PREV-001 and dependents wait on that. CE-CD-001 is required for `internal-adult-testflight` signing; it is `registered` with no packet.

9. **Locked evaluation then category specialists (G4).** After D06/D07/P07, CE-EVAL-001 signs the protocol, CE-DATA-001/002 land authorized corpora, CE-DET-002/004/005 produce researchOnly scorecards, CE-INT-001 uses approved copy IDs only. Promotion beyond `researchOnly` remains a locked evaluation gate.

10. **Week-6 formal stop/go (CE-GATE-006).** Signed accept/narrow/stop per dimension in `week6Gate`. A later demo does not excuse an earlier failed gate (`decision-scorecard.yaml` header).

11. **Connector field proof (G6) only with provider approval.** D08 already limits shipping to honest identity-only cards. CE-CONN-002/003/004 still require real provider capability fixtures before any safety-coverage credit.

12. **Independent reviews, then week-12 package (G7, G8, G9).** CE-REVIEW-001 → CE-RELEASE-001 → CE-DECISION-001. G9 requires the accepted suite on release-candidate/final SDK and every supported tier. Beta-only success does not authorize a next phase (`week12Gate` additional criteria). Leadership then chooses exactly one of the four outcomes in `specs/product.md` §1.

### First command to reproduce this session’s mechanical baseline

```bash
python3 scripts/spec_revision.py && make verify-specs && make test-contracts && make test-privacy && make test-security && make selftest
```

Observed 2026-09-15: all of the above PASS on this Linux host, spec revision `b4cfcf24d684`. Apple, device-matrix, locked-evaluation, and bench were not run here.

---

## Source map

| Claim area | File |
|---|---|
| Gates and kill criteria | `specs/decision-scorecard.yaml` |
| Decisions and preconditions | `specs/open-decisions.yaml` |
| Work packages | `specs/work-packages.yaml` |
| Task packets | `specs/tasks/*.yaml` (24 files) |
| Tenants | `specs/tenant-classes.yaml` |
| Invariants | `specs/invariants.yaml` |
| Lanes | `specs/verification-lanes.yaml` |
| Platform | `specs/platform-capabilities.md` |
| Evaluation lock | `specs/evaluation-protocol.md` |
| Exit outcomes | `specs/product.md` |
| Emitted scorecards | `artifacts/scorecards/CE-*.json` (12) |
| Dated session log | `HANDOFF.md`, `docs/results/FamilyFirst_Final_Results.md` |
