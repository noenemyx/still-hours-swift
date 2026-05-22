// SettingsRootView.swift — App/Views/Settings
// Copyright 2026 sunghun.ahn — Still Hours
// Round 15.4: Settings hierarchy root — iCloud Sync stub + Legal section + version footer
// Created: 2026-05-21

import SwiftUI
import InventoryCore

// MARK: - SettingsRootView

/// Root settings form. Presents grouped sections per Apple HIG:
/// "About", "Sync" (v1.1 stub), "Data" (export), "Legal" (privacy + links), and version footer.
///
/// Embedded inside a `NavigationStack` in `ContentView`.
@MainActor
struct SettingsRootView: View {

    // MARK: State

    /// Placeholder state — always false in v1.0; wired to CloudKit in v1.1.
    @State private var iCloudSyncEnabled = false

    // MARK: Computed

    private var versionFooter: String {
        let v = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
            as? String ?? "—"
        let b = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion")
            as? String ?? "—"
        return "Still Hours v\(v) · build \(b)"
    }

    // MARK: Body

    var body: some View {
        Form {
            // MARK: About section

            Section(
                header: Text(
                    String(
                        localized: "settings.section.about",
                        defaultValue: "About"
                    )
                )
            ) {
                NavigationLink(destination: AboutStillHoursView()) {
                    Label(
                        String(
                            localized: "settings.about.title",
                            defaultValue: "Still Hours is"
                        ),
                        systemImage: "info.circle"
                    )
                }

                // Help row owned by R15.2 — do not move or rename.
                NavigationLink(destination: HelpView()) {
                    Label(
                        String(
                            localized: "settings.help",
                            defaultValue: "Help"
                        ),
                        systemImage: "questionmark.circle"
                    )
                }
            }

            // MARK: Sync section — iCloud Sync stub (v1.1 placeholder)

            Section(
                header: Text(
                    String(
                        localized: "settings.section.sync",
                        defaultValue: "Sync"
                    )
                ),
                footer: Text(
                    String(
                        localized: "settings.sync.footer",
                        defaultValue: "Your data lives on your device only in v1.0. iCloud sync arrives in v1.1 — opt-in toggle, encrypted-at-rest via Apple CloudKit Private DB."
                    )
                )
                .font(.caption)
            ) {
                Toggle(isOn: $iCloudSyncEnabled) {
                    Label {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(
                                String(
                                    localized: "settings.sync.title",
                                    defaultValue: "iCloud Sync"
                                )
                            )
                            Text(
                                String(
                                    localized: "settings.sync.subtitle.v11",
                                    defaultValue: "Coming in v1.1"
                                )
                            )
                            .font(.caption)
                            .foregroundStyle(Color.shTextSecondary)
                        }
                    } icon: {
                        Image(systemName: "icloud.fill")
                    }
                }
                .disabled(true) // v1.1 placeholder — disabled in v1.0
            }

            // MARK: Data section

            Section(
                header: Text(
                    String(
                        localized: "settings.section.data",
                        defaultValue: "Data"
                    )
                )
            ) {
                NavigationLink(destination: ExportDataView()) {
                    Label(
                        String(
                            localized: "settings.export.title",
                            defaultValue: "Export data"
                        ),
                        systemImage: "square.and.arrow.up"
                    )
                }
            }

            // MARK: Legal section

            Section(
                header: Text(
                    String(
                        localized: "settings.section.legal",
                        defaultValue: "Legal"
                    )
                )
            ) {
                NavigationLink(destination: DataPrivacyView()) {
                    Label(
                        String(
                            localized: "settings.dataPrivacy",
                            defaultValue: "Data Privacy"
                        ),
                        systemImage: "lock.shield"
                    )
                }

                // LEGAL-PENDING: replace with live GitHub Pages URLs before launch — see docs/legal/README.md
                // LINT-IGNORE: Privacy — GitHub Pages user-site host (noenemyx.github.io); placeholder for hosted legal docs
                Link(destination: URL(string: "https://noenemyx.github.io/still-hours/legal/privacy-policy-en.html")!) { // safe: compile-time literal URL
                    Label(
                        String(
                            localized: "settings.privacyPolicy",
                            defaultValue: "Privacy Policy"
                        ),
                        systemImage: "doc.text"
                    )
                }

                // LEGAL-PENDING: replace with live GitHub Pages URLs before launch — see docs/legal/README.md
                Link(destination: URL(string: "https://noenemyx.github.io/still-hours/legal/terms-of-service-en.html")!) { // safe: compile-time literal URL
                    Label(
                        String(
                            localized: "settings.termsOfService",
                            defaultValue: "Terms of Service"
                        ),
                        systemImage: "doc.text"
                    )
                }
            }

            // MARK: Version footer

            Section(
                footer: HStack {
                    Spacer()
                    Text(versionFooter)
                        .font(.caption2)
                        .foregroundStyle(Color.shTextSecondary)
                    Spacer()
                }
            ) {
                EmptyView()
            }
        }
        .navigationTitle(
            String(localized: "nav.settings", defaultValue: "Settings")
        )
        .navigationBarTitleDisplayMode(.large)
        .background(Color.shBackground)
    }
}
