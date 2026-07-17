import SwiftUI

struct RootView: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        if model.hasOnboarded {
            MainView()
        } else {
            OnboardingView()
        }
    }
}

enum AppSection: String, CaseIterable, Identifiable {
    case dashboard = "Numbers"
    case lifeGrid = "Life in Weeks"
    case milestones = "Milestones"

    var id: String { rawValue }

    var symbolName: String {
        switch self {
        case .dashboard: "number.circle"
        case .lifeGrid: "square.grid.3x3"
        case .milestones: "flag.checkered"
        }
    }
}

struct MainView: View {
    @State private var selection: AppSection? = .dashboard
    @State private var showingSettings = false

    var body: some View {
        #if os(macOS)
        NavigationSplitView {
            List(AppSection.allCases, selection: $selection) { section in
                Label(section.rawValue, systemImage: section.symbolName)
                    .tag(section)
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
        } detail: {
            sectionView(selection ?? .dashboard)
        }
        .toolbar {
            ToolbarItem {
                settingsButton
            }
        }
        .sheet(isPresented: $showingSettings) { SettingsView() }
        #else
        TabView {
            ForEach(AppSection.allCases) { section in
                NavigationStack {
                    sectionView(section)
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                settingsButton
                            }
                        }
                }
                .tabItem { Label(section.rawValue, systemImage: section.symbolName) }
            }
        }
        .sheet(isPresented: $showingSettings) { SettingsView() }
        #endif
    }

    private var settingsButton: some View {
        Button {
            showingSettings = true
        } label: {
            Label("Settings", systemImage: "slider.horizontal.3")
        }
    }

    @ViewBuilder
    private func sectionView(_ section: AppSection) -> some View {
        switch section {
        case .dashboard: DashboardView()
        case .lifeGrid: LifeGridView()
        case .milestones: MilestonesView()
        }
    }
}

#Preview("App") {
    RootView()
        .environment(AppModel())
        .fontDesign(.serif)
        .tint(Theme.terracotta)
}
