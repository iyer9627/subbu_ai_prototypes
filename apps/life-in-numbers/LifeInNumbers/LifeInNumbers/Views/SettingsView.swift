import SwiftUI
import LifeMetricsKit

struct SettingsView: View {
    @Environment(AppModel.self) private var model
    @Environment(\.dismiss) private var dismiss
    @State private var cityAutocomplete = CityAutocomplete()
    @State private var placeOfBirthText = ""
    /// Tracks the last tapped suggestion so re-showing it isn't triggered by
    /// the onChange fired when the field is filled programmatically.
    @State private var chosenPlaceOfBirth: String?

    private static let genderOptions = ["Woman", "Man", "Non-binary", "Prefer not to say"]

    var body: some View {
        @Bindable var model = model
        NavigationStack {
            Form {
                Section("Your dates") {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Birth date")
                            .font(AppFont.serif(.caption))
                            .foregroundStyle(Theme.inkSecondary)
                        BirthDatePicker(date: $model.profile.birthDate)
                    }
                    Stepper(
                        "Life expectancy: \(model.profile.lifeExpectancyYears) years",
                        value: $model.profile.lifeExpectancyYears,
                        in: 40...120
                    )
                }

                Section("Your interest") {
                    Picker("Quotes and facts flavored by", selection: $model.interest) {
                        ForEach(Interest.allCases) { interest in
                            Label(interest.rawValue, systemImage: interest.symbolName)
                                .tag(interest)
                        }
                    }
                    Text("One at a time — it tunes the milestone quotes and the card facts to what you love.")
                        .font(AppFont.serif(.caption))
                        .foregroundStyle(.secondary)
                }

                Section("About you (optional)") {
                    Picker("Gender", selection: Binding(
                        get: { model.profile.gender ?? "" },
                        set: { model.profile.gender = $0.isEmpty ? nil : $0 }
                    )) {
                        Text("Not set").tag("")
                        ForEach(Self.genderOptions, id: \.self) { Text($0).tag($0) }
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Place of birth")
                            .font(AppFont.serif(.caption))
                            .foregroundStyle(Theme.inkSecondary)
                        TextField("City or town", text: $placeOfBirthText, prompt: Text("City or town"))
                            .multilineTextAlignment(.leading)
                            .onChange(of: placeOfBirthText) { _, newValue in
                                model.profile.placeOfBirth = newValue.isEmpty ? nil : newValue
                                if newValue == chosenPlaceOfBirth {
                                    cityAutocomplete.clear()
                                } else {
                                    chosenPlaceOfBirth = nil
                                    cityAutocomplete.update(query: newValue)
                                }
                            }
                        ForEach(cityAutocomplete.suggestions.prefix(5), id: \.self) { suggestion in
                            Button {
                                placeOfBirthText = suggestion
                                model.profile.placeOfBirth = suggestion
                                chosenPlaceOfBirth = suggestion
                                cityAutocomplete.clear()
                            } label: {
                                Text(suggestion)
                                    .font(AppFont.serif(.callout))
                                    .foregroundStyle(Theme.dustyBlue)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .onAppear {
                        // Treat the stored place as already chosen so opening
                        // Settings doesn't pop the suggestion list.
                        chosenPlaceOfBirth = model.profile.placeOfBirth
                        placeOfBirthText = model.profile.placeOfBirth ?? ""
                    }
                    Text("Used only to make your written reflections feel like yours. Stays on this device.")
                        .font(AppFont.serif(.caption))
                        .foregroundStyle(.secondary)
                }

                Section("Writing model") {
                    Picker("Model", selection: $model.reflectionModelID) {
                        ForEach(ModelCatalog.available) { option in
                            VStack(alignment: .leading) {
                                Text(option.name)
                                Text(option.subtitle)
                                    .font(AppFont.serif(.caption))
                                    .foregroundStyle(.secondary)
                            }
                            .tag(option.id)
                        }
                        if !ModelCatalog.available.contains(where: { $0.id == model.reflectionModelID }) {
                            Text("Custom (\(model.reflectionModelID))").tag(model.reflectionModelID)
                        }
                    }
                    .pickerStyle(.inline)
                    .labelsHidden()
                    Text("Only models this device can run are listed. Each downloads once, then works fully offline.")
                        .font(AppFont.serif(.caption))
                        .foregroundStyle(.secondary)
                }

                Section {
                    Text("Body counts use population averages (70 heartbeats and 14 breaths per minute, 8 hours of sleep). They are estimates for perspective, not medical data.")
                        .font(AppFont.serif(.caption))
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
        .frame(minWidth: 460, minHeight: 480)
        #endif
    }
}

#Preview {
    SettingsView()
        .environment(AppModel())
        .fontDesign(.serif)
        .tint(Theme.dustyBlue)
}
