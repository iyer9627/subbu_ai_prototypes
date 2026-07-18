import SwiftUI
import LifeMetricsKit

@main
struct LifeInNumbersApp: App {
    @State private var model = AppModel()

    init() {
        AppFont.registerFonts()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(model)
                .fontDesign(.serif)
                .tint(Theme.dustyBlue)
        }
        #if os(macOS)
        .defaultSize(width: 1000, height: 720)
        #endif

        #if os(macOS)
        // A quiet, always-available presence: live numbers in the menu bar.
        MenuBarExtra {
            MenuBarStatsView()
                .environment(model)
        } label: {
            Image(systemName: "hourglass")
        }
        .menuBarExtraStyle(.window)
        #endif
    }
}
