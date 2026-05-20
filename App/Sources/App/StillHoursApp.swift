import SwiftUI
import SwiftData
import InventoryCore

@main
struct StillHoursApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(
            for: [
                Item.self,
                Memory.self,
                InventoryCore.Collection.self,
                InventoryCore.Attachment.self,
            ]
        )
    }
}

struct RootView: View {
    var body: some View {
        Text("Still Hours")
            .font(StillHoursTypeface.display(for: Locale.current))
            .foregroundStyle(Color.shTextPrimary)
            .padding()
    }
}
