# Still Hours — Privacy Policy

Last updated: May 22, 2026  
Effective date: May 22, 2026  
Applies to: Still Hours v1.0 and later

---

## Overview

Still Hours is a tool for recording memories around the things you own. This policy explains what information Still Hours handles, what it does not handle, and why. It takes about five minutes to read.

---

## §1 What We Collect

Still Hours has no server. The developer (ownlifelab) has no access to your data.

**On-device data**  
Everything you add to the app — items, memories, collections, attachments — is stored on your device only.

**iCloud sync (optional, v1.1 and later)**  
If you explicitly enable iCloud sync in Settings, your data is written to Apple CloudKit Private Database. This database is a private space tied to your Apple ID. ownlifelab has no read, write, or view access to it. iCloud sync is off by default in v1.0.

**Metadata lookups**  
When the app fetches metadata for a book, album, or other item, it sends only the item identifier (such as an ISBN) to a third-party metadata API. Your name, location, device information, and account details are not transmitted.

**Data Apple collects**  
App Store purchases, downloads, and crash reports are processed by Apple's systems, under Apple's Privacy Policy. ownlifelab does not receive this data.

---

## §2 What We Do Not Do

The following are permanent commitments under Still Hours' Promise, applying now and in all future versions.

**No tracking**  
We do not use advertising identifiers (IDFA), advertising SDKs, third-party analytics tools, or user-behavior tracking scripts. Apple's `PrivacyInfo.xcprivacy` manifest declares `NSPrivacyTracking = false`. You can verify this in the app at Settings → Data Privacy.

**No advertising**  
There are no ads in the app. We do not use any external advertising channel, including Apple Search Ads.

**No data sale**  
We do not sell, license, or otherwise transfer your information to third parties.

**No public profile**  
There are no user accounts, public feeds, or social graphs. All collections are private by default.

**No AI judgment**  
AI does not evaluate, recommend, or auto-categorize your records. AI-assisted features — such as OCR metadata completion after a barcode scan — assist only where you invoke them, and the results are processed on-device or discarded after the request completes. No data from these requests is used for model training.

**No subscription**  
Still Hours is a one-time purchase. There is no recurring billing.

---

## §3 Third-Party Services

Still Hours relies on the following external services.

| Service | Provider | Purpose | User data transmitted |
|---------|----------|---------|----------------------|
| iCloud / CloudKit | Apple Inc. | Optional device-to-device sync | Only when user enables sync; stored in Apple's encrypted Private DB — not accessible to ownlifelab |
| App Store | Apple Inc. | App distribution and purchase processing | Apple's standard policy applies |
| Book and media metadata APIs | Various | Auto-completion of item metadata | Item identifier only (e.g., ISBN) — no user-identifying information |

No third-party SDKs, advertising networks, or analytics platforms are included beyond the above.

---

## §4 Data Sovereignty

A core commitment of Still Hours is that you can take your data with you at any time.

**Export formats**  
Go to Settings → Data Sovereignty to export your entire library as JSON, CSV, or PDF. Exported files are plain text; they can be opened without Still Hours.

**When you delete the app**  
Deleting the app removes on-device data. If you had iCloud sync enabled, data stored in CloudKit can be deleted separately in your iCloud account settings.

**If the service shuts down**  
Data you have already exported remains yours. If Still Hours is discontinued, we will provide at least 30 days' notice and keep the export function available during that period.

**No ownlifelab access**  
Your data is never stored on or transmitted to ownlifelab's servers. CloudKit data is accessible only via your Apple ID.

---

## §5 Children's Privacy

Still Hours is released with an App Store rating of 4+ (everyone). The app does not operate services directed at children under 13 and does not knowingly collect personal information from children under 13.

If you are a parent or guardian and believe a child under 13 is using the app, please contact us using the details in §8.

---

## §6 International Data Transfers

Still Hours does not perform independent international data transfers. Data resides on your device. When iCloud sync is enabled, it is handled by Apple's iCloud infrastructure, tied to your Apple ID. Apple's Privacy Policy describes where iCloud data is processed.

Metadata API calls transmit only item identifiers to the relevant service's servers. These requests contain no information that identifies you as a user.

---

## §7 Your Rights

You can exercise the following rights over your data directly within the app, without contacting ownlifelab.

**Access**  
All your data is visible to you inside the app at all times.

**Export**  
Settings → Data Sovereignty → Export (JSON / CSV / PDF). No account required, no approval needed, available immediately.

**Deletion**  
Delete individual items, memories, or collections directly in the app. To delete all data, delete the app (removes on-device data) and visit Apple's iCloud Settings → Manage Storage → Still Hours to remove CloudKit data.

**Correction**  
Edit any piece of data directly in the app.

The app is designed so that you can exercise all of these rights without sending a request to ownlifelab. If you need assistance, contact us at the address in §8.

If you are located in the European Economic Area, United Kingdom, or California, you may have additional rights under applicable law (including GDPR or CCPA). Because we collect no personal data on our servers and store nothing outside your device and your own iCloud account, most of these rights are already satisfied by the app's design. For any residual questions, contact us at §8.

---

## §8 Contact

For questions about this Privacy Policy, contact:

- **Email**: sunghun.ahn@gmail.com
- **Controller**: Sunghun Ahn (independent developer, ownlifelab)

We will respond within five business days.

---

## §9 Effective Date and Changes

**Initial effective date**: May 22, 2026

This policy is updated whenever Still Hours' Promise commitments change. Material changes are announced via the app update release notes and this document on GitHub Pages.

If a change would result in the collection of more information than described here, or extend the purposes for which data is processed, a separate in-app notification will be shown.

Previous versions of this policy are available in the commit history of the GitHub Pages repository.

---

*Still Hours is made by ownlifelab.*  
*The commitments in this policy are declared in code via Apple's `PrivacyInfo.xcprivacy` manifest. You can verify this in the app at Settings → Data Privacy.*
