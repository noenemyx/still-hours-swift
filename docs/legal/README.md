# docs/legal — Own Your Curation Legal Documents

Privacy Policy and Terms of Service for the App Store submission of Own Your Curation.

---

## Files in This Directory

| File | Language | Document |
|------|----------|----------|
| `PrivacyPolicy-ko.md` | Korean | 개인정보 처리방침 |
| `PrivacyPolicy-en.md` | English | Privacy Policy |
| `PrivacyPolicy-ja.md` | Japanese | プライバシーポリシー |
| `TermsOfService-ko.md` | Korean | 이용약관 |
| `TermsOfService-en.md` | English | Terms of Service |
| `TermsOfService-ja.md` | Japanese | 利用規約 |

---

## Hosting Recommendation: GitHub Pages

**GitHub Pages is the recommended hosting path.** It is free, public, version-controlled by the same git history as the rest of the project, and requires no database or server.

### Setup

1. In the GitHub repository settings, enable GitHub Pages from the `main` branch.
2. Select a source directory (root or `/docs`). If using root, the legal files will need to be converted and placed at the repo root. If using `/docs`, they can live here.
3. Convert Markdown to HTML before publishing (see below).

### URL Convention

Once GitHub Pages is active, published URLs follow this pattern (note: the hosting repo is named `still-hours-swift` for historical reasons; only the brand display name has changed):

```
https://noenemyx.github.io/still-hours-swift/legal/privacy-policy-en.html
https://noenemyx.github.io/still-hours-swift/legal/privacy-policy-ko.html
https://noenemyx.github.io/still-hours-swift/legal/privacy-policy-ja.html
```

For App Store submission, you will need at least the English URL. Use the English Privacy Policy URL in App Store Connect → App Information → Privacy Policy URL.

### Markdown to HTML Conversion

Use `pandoc` to convert each `.md` file to a standalone `.html` file:

```bash
pandoc PrivacyPolicy-en.md \
  -o privacy-policy-en.html \
  --standalone \
  --metadata title="Own Your Curation Privacy Policy"

pandoc PrivacyPolicy-ko.md \
  -o privacy-policy-ko.html \
  --standalone \
  --metadata title="Own Your Curation 개인정보 처리방침"

pandoc PrivacyPolicy-ja.md \
  -o privacy-policy-ja.html \
  --standalone \
  --metadata title="Own Your Curation プライバシーポリシー"

pandoc TermsOfService-en.md \
  -o terms-of-service-en.html \
  --standalone \
  --metadata title="Own Your Curation Terms of Service"

pandoc TermsOfService-ko.md \
  -o terms-of-service-ko.html \
  --standalone \
  --metadata title="Own Your Curation 이용약관"

pandoc TermsOfService-ja.md \
  -o terms-of-service-ja.html \
  --standalone \
  --metadata title="Own Your Curation 利用規約"
```

Install pandoc if not present: `brew install pandoc`

Commit the generated `.html` files to the repo. GitHub Pages serves static files directly.

### Alternative: Vercel

If you prefer Vercel, add a `vercel.json` at the repo root with a static build configuration. Vercel's free hobby tier works for static sites. URL structure is the same.

---

## App Store Connect Submission

1. Convert `PrivacyPolicy-en.md` to HTML and publish it at the GitHub Pages URL.
2. In App Store Connect, navigate to your app → App Information.
3. Paste the URL into the **Privacy Policy URL** field.
4. Terms of Service URL is optional but recommended for paid apps. Paste the English Terms URL in the same section if present.

App Review checks that the URL resolves and that the page addresses the app's actual data practices. The policy in this directory is consistent with the `PrivacyInfo.xcprivacy` manifest declaration (`NSPrivacyTracking = false`, zero collected data types).

---

## Update Protocol

Any change to the Own Your Curation Promise (PRD §5) requires:

1. Update the relevant sections in all six locale files.
2. Bump the "Last updated" date at the top of each file.
3. Convert to HTML and push to GitHub Pages.
4. Update the App Store Connect Privacy Policy URL if the URL changes.
5. If the change adds new data collection or extends processing purposes, add an in-app notification in the next app update.

The Promise covers: No algorithm / No feed / No advertising / No data sale / No AI judgment / No subscription / Data Sovereignty (export always available, CloudKit Private DB only).
