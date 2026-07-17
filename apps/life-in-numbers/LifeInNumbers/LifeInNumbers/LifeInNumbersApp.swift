import SwiftUI

@main
struct LifeInNumbersApp: App {
    @State private var model = AppModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(model)
                .fontDesign(.serif)
                .tint(Theme.terracotta)
        }
        #if os(macOS)
        .defaultSize(width: 1000, height: 720)
        #endif
    }
}
