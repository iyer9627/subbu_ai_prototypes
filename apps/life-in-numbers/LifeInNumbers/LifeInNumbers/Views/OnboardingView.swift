import SwiftUI
import LifeMetricsKit

struct OnboardingView: View {
    @Environment(AppModel.self) private var model
    @State private var birthDate = Calendar.current.date(byAdding: .year, value: -30, to: .now) ?? .now

    var body: some View {
        ZStack {
            Theme.paper.ignoresSafeArea()
            VStack(spacing: 28) {
                Spacer()

                Image("OnboardingHero")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 240)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .shadow(color: .black.opacity(0.10), radius: 8, y: 4)
                    .accessibilityLabel("A watercolor dog in a beret watching an hourglass")

                VStack(spacing: 10) {
                    Text("Life in Numbers")
                        .font(.largeTitle.weight(.semibold))
                        .foregroundStyle(Theme.ink)
                    Text("Your whole story, counted. Heartbeats, breaths, weeks, and trips around the Sun — all from one date.")
                        .font(.body)
                        .foregroundStyle(Theme.inkSecondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 420)
                }

                VStack(spacing: 16) {
                    Text("When were you born?")
                        .font(.headline)
                        .foregroundStyle(Theme.ink)
                    DatePicker(
                        "Birth date",
                        selection: $birthDate,
                        in: ...Date.now,
                        displayedComponents: .date
                    )
                    .labelsHidden()
                    .datePickerStyle(.graphical)
                    .frame(maxWidth: 360)
                }
                .padding(24)
                .paperCard()
                .padding(.horizontal)

                Button {
                    model.profile.birthDate = birthDate
                    model.hasOnboarded = true
                } label: {
                    Text("Count My Life")
                        .font(.headline)
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
        .tint(Theme.terracotta)
}
