import SwiftUI
import LifeMetricsKit

struct SettingsView: View {
    @Environment(AppModel.self) private var model
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        @Bindable var model = model
        NavigationStack {
            Form {
                Section("Your dates") {
                    DatePicker(
                        "Birth date",
                        selection: $model.profile.birthDate,
                        in: ...Date.now,
                        displayedComponents: .date
                    )
                    Stepper(
                        "Life expectancy: \(model.profile.lifeExpectancyYears) years",
                        value: $model.profile.lifeExpectancyYears,
                        in: 40...120
                    )
                }
                Section {
                    Text("Body counts use population averages (70 heartbeats and 14 breaths per minute, 8 hours of sleep). They are estimates for perspective, not medical data.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .formStyle(.grouped)
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
        #if os(macOS)
        .frame(minWidth: 420, minHeight: 320)
        #endif
    }
}
