import SwiftUI
import LifeMetricsKit

/// "Your life in weeks": one small box per week of the expected lifespan,
/// 52 to a row, painted like pigment on paper.
struct LifeGridView: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        let grid = WeeksGrid(profile: model.profile, asOf: .now, calculator: model.calculator)
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ArtHeader(imageName: "GridArt",
                          label: "A watercolor dog lying on a grid of colored squares")
                summary(for: grid)
                gridCanvas(for: grid)
                    .padding(16)
                    .paperCard()
                legend
            }
            .padding()
        }
        .background(Theme.paper)
        .navigationTitle("Life in Weeks")
    }

    private func summary(for grid: WeeksGrid) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(grid.weeksLived.formatted()) weeks lived")
                .font(.title2.weight(.semibold))
                .foregroundStyle(Theme.ink)
            Text("\(grid.weeksRemaining.formatted()) to go in a \(model.profile.lifeExpectancyYears)-year life — each box is one week.")
                .font(.subheadline)
                .foregroundStyle(Theme.inkSecondary)
        }
    }

    private func gridCanvas(for grid: WeeksGrid) -> some View {
        let columns = WeeksGrid.columnsPerRow
        let rows = grid.rows
        return Canvas { context, size in
            let spacing = 1.5
            let cell = (size.width - CGFloat(columns - 1) * spacing) / CGFloat(columns)
            for week in 0..<grid.totalWeeks {
                let row = week / columns
                let column = week % columns
                let rect = CGRect(
                    x: CGFloat(column) * (cell + spacing),
                    y: CGFloat(row) * (cell + spacing),
                    width: cell,
                    height: cell
                )
                let path = Path(roundedRect: rect, cornerRadius: cell * 0.25)
                if grid.isCurrent(week: week) {
                    context.fill(path, with: .color(Theme.dustyBlue))
                } else if grid.isLived(week: week) {
                    context.fill(path, with: .color(Theme.terracotta.opacity(0.85)))
                } else {
                    context.fill(path, with: .color(Theme.faded))
                }
            }
        }
        .aspectRatio(CGFloat(columns) / CGFloat(rows), contentMode: .fit)
        .accessibilityLabel("Life grid: \(grid.weeksLived) of \(grid.totalWeeks) weeks lived")
    }

    private var legend: some View {
        HStack(spacing: 20) {
            legendItem(color: Theme.terracotta.opacity(0.85), label: "Lived")
            legendItem(color: Theme.dustyBlue, label: "This week")
            legendItem(color: Theme.faded, label: "Ahead")
        }
        .font(.caption)
        .foregroundStyle(Theme.inkSecondary)
    }

    private func legendItem(color: Color, label: String) -> some View {
        HStack(spacing: 6) {
            RoundedRectangle(cornerRadius: 3)
                .fill(color)
                .frame(width: 12, height: 12)
            Text(label)
        }
    }
}

#Preview {
    NavigationStack { LifeGridView() }
        .environment(AppModel())
        .fontDesign(.serif)
        .tint(Theme.terracotta)
}
