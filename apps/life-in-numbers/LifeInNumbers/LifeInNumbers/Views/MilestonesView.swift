import SwiftUI
import LifeMetricsKit

struct MilestonesView: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        let milestones = model.milestoneGenerator.upcomingMilestones(for: model.profile, asOf: .now)
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ArtHeader(imageName: "MilestonesArt",
                          label: "A watercolor cake with one candle on a hillside path lined with flags")
                VStack(alignment: .leading, spacing: 4) {
                    Text("Coming up")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(Theme.ink)
                    Text("Round numbers worth celebrating.")
                        .font(.subheadline)
                        .foregroundStyle(Theme.inkSecondary)
                }
                ForEach(Array(milestones.enumerated()), id: \.element.id) { index, milestone in
                    MilestoneRowView(milestone: milestone, pigment: Theme.pigment(at: index))
                }
            }
            .padding()
        }
        .background(Theme.paper)
        .navigationTitle("Milestones")
    }
}

struct MilestoneRowView: View {
    let milestone: Milestone
    let pigment: Color

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: milestone.symbolName)
                .font(.title3)
                .foregroundStyle(pigment)
                .frame(width: 36, height: 36)
                .background(Circle().fill(pigment.opacity(0.15)))

            VStack(alignment: .leading, spacing: 2) {
                Text(milestone.title)
                    .font(.headline)
                    .foregroundStyle(Theme.ink)
                Text(milestone.detail)
                    .font(.caption)
                    .foregroundStyle(Theme.inkSecondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(milestone.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(Theme.ink)
                Text(milestone.date, format: .relative(presentation: .named))
                    .font(.caption)
                    .foregroundStyle(pigment)
            }
        }
        .padding(14)
        .paperCard()
    }
}

#Preview {
    NavigationStack { MilestonesView() }
        .environment(AppModel())
        .fontDesign(.serif)
        .tint(Theme.terracotta)
}
