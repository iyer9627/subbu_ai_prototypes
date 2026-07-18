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
                        .font(AppFont.serif(.title2, .semibold))
                        .foregroundStyle(Theme.ink)
                    Text("Round numbers worth celebrating. Flip one for a line written by an author who was your age then.")
                        .font(AppFont.serif(.subheadline))
                        .foregroundStyle(Theme.inkSecondary)
                }
                ForEach(Array(milestones.enumerated()), id: \.element.id) { index, milestone in
                    MilestoneRowView(
                        milestone: milestone,
                        pigment: Theme.pigment(at: index),
                        ageAtMilestone: ageAt(milestone.date)
                    )
                }
            }
            .padding()
        }
        .background(Theme.paper)
        .navigationTitle("Milestones")
    }

    private func ageAt(_ date: Date) -> Int {
        max(0, Calendar.current.dateComponents([.year], from: model.profile.birthDate, to: date).year ?? 0)
    }
}

struct MilestoneRowView: View {
    let milestone: Milestone
    let pigment: Color
    let ageAtMilestone: Int

    @Environment(AppModel.self) private var model
    @State private var isFlipped = false
    @State private var quoteOrder: [BookQuote] = []
    @State private var quoteIndex = 0

    private var currentQuote: BookQuote? {
        quoteOrder.isEmpty ? nil : quoteOrder[quoteIndex % quoteOrder.count]
    }

    var body: some View {
        ZStack {
            front
                .opacity(isFlipped ? 0 : 1)
                .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
            back
                .opacity(isFlipped ? 1 : 0)
                .rotation3DEffect(.degrees(isFlipped ? 0 : -180), axis: (x: 0, y: 1, z: 0))
        }
        .contentShape(Rectangle())
        .onTapGesture { flip() }
        .accessibilityHint("Tap to flip for a book quote from an author your age")
    }

    private func flip() {
        if quoteOrder.isEmpty {
            quoteOrder = QuoteBank.pool(forAge: ageAtMilestone, interest: model.interest).shuffled()
        }
        withAnimation(.spring(duration: 0.5)) {
            if isFlipped {
                isFlipped = false
            } else {
                // A fresh quote on every flip, cycling without repeats.
                quoteIndex = (quoteIndex + 1) % max(quoteOrder.count, 1)
                isFlipped = true
            }
        }
    }

    private var front: some View {
        HStack(spacing: 14) {
            Image(systemName: milestone.symbolName)
                .font(.title3)
                .foregroundStyle(pigment)
                .frame(width: 36, height: 36)
                .background(Circle().fill(pigment.opacity(0.15)))

            VStack(alignment: .leading, spacing: 2) {
                Text(milestone.title)
                    .font(AppFont.serif(.headline, .semibold))
                    .foregroundStyle(Theme.ink)
                Text(milestone.detail)
                    .font(AppFont.serif(.caption))
                    .foregroundStyle(Theme.inkSecondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(milestone.date.formatted(date: .abbreviated, time: .omitted))
                    .font(AppFont.serif(.subheadline, .medium))
                    .foregroundStyle(Theme.ink)
                Text(milestone.date, format: .relative(presentation: .named))
                    .font(AppFont.serif(.caption))
                    .foregroundStyle(pigment)
                Image(systemName: "arrow.2.squarepath")
                    .font(.caption2)
                    .foregroundStyle(Theme.faded)
            }
        }
        .padding(14)
        .paperCard()
    }

    @ViewBuilder
    private var back: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let quote = currentQuote {
                Text("“\(quote.text)”")
                    .font(AppFont.serifItalic(.body))
                    .foregroundStyle(Theme.ink)
                    .fixedSize(horizontal: false, vertical: true)
                Text("— \(quote.author), \(quote.book) (\(String(quote.publicationYear)))")
                    .font(AppFont.serif(.caption))
                    .foregroundStyle(Theme.inkSecondary)
                Text("\(quote.author.components(separatedBy: " ").last ?? quote.author) was \(quote.authorAgeAtPublication) when this was published — you'll be \(ageAtMilestone) at this milestone.")
                    .font(AppFont.serif(.caption))
                    .foregroundStyle(pigment)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .paperCard()
    }
}

#Preview {
    NavigationStack { MilestonesView() }
        .environment(AppModel())
        .fontDesign(.serif)
        .tint(Theme.dustyBlue)
}
