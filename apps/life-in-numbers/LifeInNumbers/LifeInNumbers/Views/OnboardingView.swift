import SwiftUI
import LifeMetricsKit

struct OnboardingView: View {
    @Environment(AppModel.self) private var model
    @State private var birthDate = Calendar.current.date(byAdding: .year, value: -30, to: .now) ?? .now
    @State private var gender = ""
    @State private var placeOfBirth = ""
    @State private var interest: Interest = .books
    @State private var cityAutocomplete = CityAutocomplete()
    /// Tracks the last tapped suggestion so re-showing it isn't triggered by
    /// the onChange fired when the field is filled programmatically.
    @State private var chosenPlaceOfBirth: String?

    var body: some View {
        ZStack {
            Theme.paper.ignoresSafeArea()
            VStack(spacing: 28) {
                Spacer()

                Image("OnboardingHero")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 240)
                    .overlay(LoopingVideoView(resourceName: "hero"))
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .shadow(color: .black.opacity(0.10), radius: 8, y: 4)
                    .accessibilityLabel("A watercolor dog in a beret watching an hourglass, gently animated")

                VStack(spacing: 10) {
                    Text("Life in Numbers")
                        .font(AppFont.serif(.largeTitle, .semibold))
                        .foregroundStyle(Theme.ink)
                    Text("Your whole story, counted. Heartbeats, breaths, weeks, and trips around the Sun — all from one date.")
                        .font(AppFont.serif(.body))
                        .foregroundStyle(Theme.inkSecondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 420)
                }

                VStack(spacing: 16) {
                    Text("When were you born?")
                        .font(AppFont.serif(.headline, .semibold))
                        .foregroundStyle(Theme.ink)
                    BirthDatePicker(date: $birthDate)
                        .frame(maxWidth: 360)

                    Divider()

                    HStack(spacing: 12) {
                        Picker("Gender", selection: $gender) {
                            Text("Gender (optional)").tag("")
                            ForEach(["Woman", "Man", "Non-binary", "Prefer not to say"], id: \.self) {
                                Text($0).tag($0)
                            }
                        }
                        .labelsHidden()
                        TextField("Born in… (optional)", text: $placeOfBirth)
                            .textFieldStyle(.roundedBorder)
                            .onChange(of: placeOfBirth) { _, newValue in
                                if newValue == chosenPlaceOfBirth {
                                    cityAutocomplete.clear()
                                } else {
                                    chosenPlaceOfBirth = nil
                                    cityAutocomplete.update(query: newValue)
                                }
                            }
                    }
                    .frame(maxWidth: 360)

                    if !cityAutocomplete.suggestions.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            ForEach(cityAutocomplete.suggestions.prefix(5), id: \.self) { suggestion in
                                Button {
                                    placeOfBirth = suggestion
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
                        .frame(maxWidth: 360)
                    }

                    Picker("What do you love?", selection: $interest) {
                        ForEach(Interest.allCases) { option in
                            Label(option.rawValue, systemImage: option.symbolName)
                                .tag(option)
                        }
                    }
                    .frame(maxWidth: 360)
                }
                .padding(24)
                .paperCard()
                .padding(.horizontal)

                Button {
                    model.profile.birthDate = birthDate
                    model.profile.gender = gender.isEmpty ? nil : gender
                    model.profile.placeOfBirth = placeOfBirth.isEmpty ? nil : placeOfBirth
                    model.interest = interest
                    model.hasOnboarded = true
                } label: {
                    Text("Count My Life")
                        .font(AppFont.serif(.headline, .semibold))
                        .padding(.horizontal, 28)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.borderedProminent)

                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    OnboardingView()
        .environment(AppModel())
        .fontDesign(.serif)
        .tint(Theme.dustyBlue)
}
