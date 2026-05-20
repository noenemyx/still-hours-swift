// SettingsRootView.swift — App/Views/Settings
// Copyright 2026 sunghun.ahn — Still Hours
// Round 7: Settings hierarchy root
// Created: 2026-05-21

import SwiftUI
import InventoryCore

// MARK: - SettingsRootView

/// Root settings form. Presents three grouped sections:
/// "About", "Data" (export + privacy), and app meta.
///
/// Embedded inside a `NavigationStack` in `ContentView`.
@MainActor
struct SettingsRootView: View {

    // MARK: Computed

    private var appVersion: String {
        let v = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
            as? String ?? "—"
        let b = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion")
            as? String ?? "—"
        return "\(v) (\(b))"
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

                NavigationLink(destination: DataPrivacyView()) {
                    Label(
                        String(
                            localized: "settings.dataPrivacy",
                            defaultValue: "Data Privacy"
                        ),
                        systemImage: "lock.shield"
                    )
                }
            }

            // MARK: App meta section

            Section {
                HStack {
                    Label(
                        String(
                            localized: "settings.help",
                            defaultValue: "Help"
                        ),
                        systemImage: "questionmark.circle"
                    )
                    Spacer()
                    Image(systemName: "arrow.up.right.square")
                        .foregroundStyle(Color.shTextSecondary)
                        .font(.caption)
                }
                .contentShape(Rectangle())

                HStack {
                    Text(
                        String(
                            localized: "settings.version",
                            defaultValue: "Version"
                        )
                    )
                    .foregroundStyle(Color.shTextPrimary)
                    Spacer()
                    Text(appVersion)
                        .foregroundStyle(Color.shTextSecondary)
                        .font(.subheadline)
                }
            }
        }
        .navigationTitle(
            String(localized: "nav.settings", defaultValue: "Settings")
        )
        .navigationBarTitleDisplayMode(.large)
        .background(Color.shBackground)
    }
}
