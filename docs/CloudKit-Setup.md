# CloudKit Setup — Still Hours

> Reference: PRD.md §10 Promise §1 (Data Sovereignty), §11 Privacy.
> DEVPLAN.md §4 CloudKit integration scope.

---

## §1 Container ID Strategy

Single container for all user data:

```
iCloud.com.ownlifelab.stillhours
```

One container ID covers all record types across all app versions. There is no
secondary container and no container-per-feature split. This keeps schema
evolution, quota attribution, and debugging in a single namespace.

The container is declared in `App/Resources/StillHours.entitlements` under both
`com.apple.developer.icloud-container-identifiers` and
`com.apple.developer.ubiquity-container-identifiers`.

---

## §2 Promise §1 Boundaries — Private DB Only

**Promise §1 (Data Sovereignty)** is a permanent product commitment:

- All user data is stored in the CloudKit **Private Database** exclusively.
- The **Public Database** is NEVER used — it is not listed in `icloud-services`
  and must never be added without a formal Promise amendment and explicit user
  approval.
- The **Shared Database** is not used in v1.0. CKShare in v1.5 routes through
  the Private DB container (see §5).

Enforcement:
- `icloud-services` in the entitlements lists only `CloudDocuments` and
  `CloudKit`. It does NOT include `public`.
- A future `scripts/check-cloudkit-scope.sh` lint (see §9) will verify no code
  path opens `.public` or `.shared` database scopes without a Promise amendment.

Consequence of violation: adding `.public` to any CKDatabase access requires
(a) a filed Promise amendment, (b) user-visible changelog disclosure, and
(c) a new App Store privacy declaration before submission.

---

## §3 Schema Scope — Record Types

SwiftData `@Model` entities map 1:1 to CloudKit record types. The mapping is
managed automatically by SwiftData's CloudKit integration; no manual schema
JSON is required.

| @Model entity  | CloudKit record type (auto-generated) | Notes                          |
|----------------|---------------------------------------|--------------------------------|
| `Item`         | `CD_Item`                             | Core inventory unit            |
| `Memory`       | `CD_Memory`                           | Voice/photo/text memo          |
| `Collection`   | `CD_Collection`                       | Grouping container             |
| `Attachment`   | `CD_Attachment`                       | Binary asset reference         |

Record type names are prefixed `CD_` by SwiftData's CloudKit bridge. Do not
manually create record types in the CloudKit Dashboard that duplicate these —
let SwiftData own the schema.

All records are stored in the Private DB. Zone: `com.apple.coredata.cloudkit.zone`
(default zone created by SwiftData's ModelContainer initialization).

---

## §4 Sync Model

SwiftData's `.cloudKitDatabase(.private)` ModelConfiguration drives all sync.

```swift
// ModelContainer initialization (App/Sources/App.swift)
let schema = Schema([Item.self, Memory.self, Collection.self, Attachment.self])
let config = ModelConfiguration(
    schema: schema,
    cloudKitDatabase: .private("iCloud.com.ownlifelab.stillhours")
)
let container = try ModelContainer(for: schema, configurations: [config])
```

Key behaviors:
- Sync is automatic for all `@Model` types in the schema.
- No manual `CKOperation` code is needed for basic CRUD.
- Conflict resolution uses last-write-wins (CloudKit default).
- Offline edits are queued locally and uploaded when connectivity resumes.
- SwiftData handles zone creation, token tracking, and push subscription
  (`CKDatabaseSubscription`) internally.

Do NOT bypass SwiftData with direct `CKRecord` writes for entities that are
`@Model` types — this breaks the sync graph. Use direct `CKRecord` only for
attachment binary uploads (CKAsset), which SwiftData references by URL.

---

## §5 v1.5 CKShare Plan — 1-to-1 Intimate Sharing

CKShare enables sharing a subset of records with a specific iCloud user.

**Promise §4 boundaries for v1.5:**
- Sharing is strictly 1-to-1 (one owner → one participant).
- No group shares. No public share links. No "anyone with the link" access.
- Shared content is a user-chosen `Collection` or individual `Item`, never the
  full Private DB.

**Entitlement impact:** none. CKShare operates within the existing Private DB
container. The `StillHours.entitlements` file requires no change at v1.5.

**Implementation sketch:**
1. Owner creates a `CKShare` rooted at the target `CKRecord`.
2. App generates a share URL via `CKShare.url`.
3. Share URL is sent to the participant out-of-band (AirDrop / Messages /
   copy-paste). No in-app social graph.
4. Participant accepts via `UICloudSharingController` or URL handler.
5. Participant's app opens the shared records in a read-only or read-write view
   (owner decides per share).
6. SwiftData's shared zone handling keeps shared records in a separate zone
   from the owner's private data.

CKShare implementation is deferred to v1.5. No placeholder code should be added
in v1.0 or v1.1 that references `CKShare`.

---

## §6 Apple Developer Setup Checklist (User Action Required)

After Apple Developer Program enrollment:

- [ ] Open Xcode → project target → Signing & Capabilities
- [ ] Add capability: **iCloud**
- [ ] Under iCloud options, enable **CloudKit**
- [ ] Click **+** under CloudKit Containers and add:
      `iCloud.com.ownlifelab.stillhours`
- [ ] Verify the container appears in the CloudKit Dashboard at
      developer.apple.com (CloudKit Console)
- [ ] In the CloudKit Dashboard, confirm the **Development** environment schema
      is initialized (run the app once on a device/simulator with an iCloud
      account signed in)
- [ ] Before TestFlight or App Store submission, deploy the schema to
      **Production** via the CloudKit Dashboard → "Deploy Schema Changes"
- [ ] Fill in `DEVELOPMENT_TEAM` in `Configs/Debug.xcconfig` and
      `Configs/Release.xcconfig` locally (do NOT commit the Team ID value)

---

## §7 Local Dev Testing

**iCloud account in Simulator:**
- Xcode Simulator supports iCloud Drive and CloudKit in the Private DB.
- Sign in: Simulator → Settings → Sign in to your Apple ID (use a personal or
  sandbox Apple ID, not a production App Store account during development).
- First launch initializes the CloudKit zone. Allow a few seconds for
  `CKDatabaseSubscription` registration to complete.

**Graceful degradation — no iCloud signed in:**
SwiftData's `.cloudKitDatabase(.private(...))` falls back gracefully when no
iCloud account is signed in. Data is stored locally in the persistent store only;
sync resumes when an account is added. No crash, no data loss.

Test this path explicitly:
1. Sign out of iCloud in Simulator Settings.
2. Launch the app. Verify all CRUD operations work locally.
3. Sign back in. Verify previously created records sync to CloudKit.

**Offline / airplane mode:**
SwiftData queues pending changes in the local store. Re-enable networking and
verify the upload completes (observe via CloudKit Dashboard → Telemetry).

---

## §8 Schema Migration Safety

CloudKit records are immutable in field type once deployed to Production. Rules:

**Safe changes (additive):**
- Adding a new optional field to an `@Model` type — SwiftData generates a new
  CloudKit record field; old records simply lack the field (nil).
- Adding a new `@Model` type — generates a new CloudKit record type.

**Breaking changes (require migration plan):**
- Renaming a field — CloudKit sees this as delete + add; old data is lost.
- Changing a field type — rejected by CloudKit schema validation.
- Removing a field — old records retain the orphan field in CloudKit (harmless
  but wastes quota).

**Migration protocol:**
1. Write a SwiftData `VersionedSchema` and `SchemaMigrationPlan` in
   `App/Sources/Data/MigrationPlan.swift`.
2. Deploy the updated schema to CloudKit Development environment first.
3. Test migration on a device with existing data.
4. Deploy to Production in CloudKit Dashboard before submitting the new app
   version to App Store Review.
5. Never submit an app version that requires a schema change to Production
   before the schema is deployed — clients on the new version will hit
   `CKError.serverRejectedRequest` until the schema is live.

Reference: `App/Sources/Data/MigrationPlan.swift` (scaffold added in Sprint 1.2).

---

## §9 Promise Lint Integration Plan

A future script `scripts/check-cloudkit-scope.sh` will enforce Promise §1 at
CI time. Planned checks:

```bash
# Fail if any Swift file references .public or .shared CKDatabase scope
# outside an explicit Promise-amendment comment block.
grep -rn "\.public\b" App/Sources/ | grep -v "// PROMISE_AMENDMENT:" && exit 1
grep -rn "\.shared\b" App/Sources/ | grep -v "// PROMISE_AMENDMENT:" && exit 1

# Fail if entitlements file lists "public" in icloud-services
grep -q '"public"' App/Resources/StillHours.entitlements && exit 1
```

Integration target: pre-commit hook (`.git/hooks/pre-commit`) and the main
test scheme (`StillHours` → Test action → pre-action shell script).

This script is NOT yet written. It is listed here so the v1.5 or later
implementation sprint includes it as a mandatory deliverable alongside any
Promise-adjacent feature work.

---

## §10 References

- Apple Developer Documentation, CloudKit section — CloudKit framework overview,
  CKContainer, CKDatabase, CKRecord, CKShare, CKDatabaseSubscription.
- Apple Developer Documentation, SwiftData + CloudKit integration — ModelConfiguration
  with `cloudKitDatabase`, automatic sync behavior, conflict resolution.
- Apple Developer Documentation, CloudKit Console (dashboard) — schema management,
  Development vs Production environment, Deploy Schema Changes.
- PRD.md §10 Promise §1 (Data Sovereignty) — binding product commitment.
- PRD.md §11 Privacy — data handling declarations for App Store.
- DEVPLAN.md — Sprint breakdown including CloudKit integration milestones.
- `App/Resources/StillHours.entitlements` — entitlement declarations.
- `Configs/Debug.xcconfig`, `Configs/Release.xcconfig` — build settings.
- `App/Sources/Data/MigrationPlan.swift` — versioned schema migration scaffold.
