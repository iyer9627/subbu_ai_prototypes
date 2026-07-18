import SwiftUI
import LifeMetricsKit

/// "Life in months": one box per month, 12 to a row so every row is a year.
/// Months holding a memory show its icon — tap any month to add or edit one.
/// The grid doubles as a simple personal diary.
struct LifeGridView: View {
    @Environment(AppModel.self) private var model
    @State private var editing: MonthSelection?

    private var calendar: Calendar { Calendar.current }

    var body: some View {
        let grid = MonthsGrid(profile: model.profile, asOf: .now, calculator: model.calculator)
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ArtHeader(imageName: "GridArt",
                          label: "A watercolor dog lying on a grid of colored squares")
                summary(for: grid)
                gridCanvas(for: grid)
                    .padding(12)
                    .paperCard()
                legend
                diaryList
            }
            .padding()
        }
        .onAppear {
            model.seedDiaryIfNeeded()
        }
        .background(Theme.paper)
        .navigationTitle("Life in Months")
        .sheet(item: $editing) { selection in
            MemoryEditorView(selection: selection, monthsLived: grid.monthsLived)
        }
    }

    private func summary(for grid: MonthsGrid) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(grid.monthsLived.formatted()) months lived")
                .font(AppFont.serif(.title2, .semibold))
                .foregroundStyle(Theme.ink)
            Text("Each box is one month; each row is one year. Tap a month to keep a memory there.")
                .font(AppFont.serif(.subheadline))
                .foregroundStyle(Theme.inkSecondary)
        }
    }

    // MARK: - Grid

    private func gridCanvas(for grid: MonthsGrid) -> some View {
        let columns = MonthsGrid.columnsPerRow
        let rows = grid.rows
        let spacing = 2.0
        // The animation timeline makes the current month breathe gently.
        return TimelineView(.animation(minimumInterval: 1.0 / 12)) { timeline in
        Canvas { context, size in
            let cell = (size.width - CGFloat(columns - 1) * spacing) / CGFloat(columns)
            let pulse = 0.30 + 0.70 * (0.5 + 0.5 * sin(timeline.date.timeIntervalSinceReferenceDate * 2.4))
            // Two memories can share a month (e.g. one moved onto another),
            // so never build this with uniqueKeysWithValues — it traps.
            let eventMonths = Dictionary(model.events.map { ($0.monthIndex, $0) },
                                         uniquingKeysWith: { first, _ in first })
            for month in 0..<grid.totalMonths {
                let row = month / columns
                let column = month % columns
                let rect = CGRect(
                    x: CGFloat(column) * (cell + spacing),
                    y: CGFloat(row) * (cell + spacing),
                    width: cell,
                    height: cell
                )
                let path = Path(roundedRect: rect, cornerRadius: cell * 0.25)
                if eventMonths[month] != nil {
                    context.fill(path, with: .color(Theme.sage))
                } else if grid.isCurrent(month: month) {
                    context.fill(path, with: .color(Theme.dustyBlue.opacity(pulse)))
                } else if grid.isLived(month: month) {
                    context.fill(path, with: .color(Theme.terracotta.opacity(0.55)))
                } else {
                    context.fill(path, with: .color(Theme.faded))
                }
                if let event = eventMonths[month], let symbol = context.resolveSymbol(id: event.id) {
                    if MemoryIconArt.assets[event.symbolName] != nil {
                        // The watercolor painting fills the whole cell,
                        // clipped to the same rounded shape.
                        var art = context
                        art.clip(to: path)
                        art.draw(symbol, in: rect)
                    } else {
                        let inset = cell * 0.18
                        context.draw(symbol, in: rect.insetBy(dx: inset, dy: inset))
                    }
                }
            }
        } symbols: {
            ForEach(model.events) { event in
                Group {
                    if let asset = MemoryIconArt.assets[event.symbolName] {
                        // Resolve small: the canvas redraws every pulse tick,
                        // so don't rasterize the full-size painting each time.
                        Image(asset)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 64, height: 64)
                    } else {
                        Image(systemName: event.symbolName)
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.white)
                    }
                }
                .tag(event.id)
            }
        }
        .aspectRatio(aspectRatio(columns: columns, rows: rows, spacing: spacing), contentMode: .fit)
        .accessibilityLabel("Life grid: \(grid.monthsLived) of \(grid.totalMonths) months lived, \(model.events.count) memories. Use the memories list below to browse them.")
        .overlay(
            GeometryReader { proxy in
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture { location in
                        handleTap(at: location, in: proxy.size, grid: grid, spacing: spacing)
                    }
            }
        )
        }
    }

    private func aspectRatio(columns: Int, rows: Int, spacing: Double) -> CGFloat {
        // Approximate: cells are square, so ratio ~ columns / rows.
        CGFloat(columns) / CGFloat(max(rows, 1))
    }

    private func handleTap(at location: CGPoint, in size: CGSize, grid: MonthsGrid, spacing: Double) {
        let columns = MonthsGrid.columnsPerRow
        let cell = (size.width - CGFloat(columns - 1) * spacing) / CGFloat(columns)
        let column = min(columns - 1, max(0, Int(location.x / (cell + spacing))))
        let row = max(0, Int(location.y / (cell + spacing)))
        let month = row * columns + column
        // Memories live in the past (or this month).
        guard month <= grid.monthsLived, month < grid.totalMonths else { return }
        editing = MonthSelection(monthIndex: month, event: model.event(atMonth: month))
    }

    // MARK: - Legend & diary

    private var legend: some View {
        HStack(spacing: 16) {
            legendItem(color: Theme.terracotta.opacity(0.55), label: "Lived")
            legendItem(color: Theme.dustyBlue, label: "This month")
            legendItem(color: Theme.sage, label: "Memory")
            legendItem(color: Theme.faded, label: "Ahead")
        }
        .font(AppFont.serif(.caption))
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

    private var diaryList: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Memories")
                .font(AppFont.serif(.title3, .semibold))
                .foregroundStyle(Theme.ink)
            if model.events.isEmpty {
                Text("Tap any lived month above to keep your first memory.")
                    .font(AppFont.serif(.subheadline))
                    .foregroundStyle(Theme.inkSecondary)
            }
            ForEach(model.events) { event in
                Button {
                    editing = MonthSelection(monthIndex: event.monthIndex, event: event)
                } label: {
                    MemoryRowView(event: event, birthDate: model.profile.birthDate)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

/// A tapped month, with its memory if one exists there.
struct MonthSelection: Identifiable {
    let monthIndex: Int
    let event: LifeEvent?
    var id: Int { monthIndex }
}

struct MemoryRowView: View {
    let event: LifeEvent
    let birthDate: Date

    var body: some View {
        HStack(spacing: 12) {
            MemoryIconView(symbolName: event.symbolName)
                .frame(width: 44, height: 44)
                .background(RoundedRectangle(cornerRadius: 10).fill(Theme.sage))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            VStack(alignment: .leading, spacing: 2) {
                Text(event.title)
                    .font(AppFont.serif(.headline, .semibold))
                    .foregroundStyle(Theme.ink)
                Text(Self.subtitle(for: event, birthDate: birthDate))
                    .font(AppFont.serif(.caption))
                    .foregroundStyle(Theme.inkSecondary)
                if let note = event.note, !note.isEmpty {
                    Text(note)
                        .font(AppFont.serif(.caption))
                        .foregroundStyle(Theme.inkSecondary)
                        .italic()
                }
                if let filename = event.audioFilename {
                    VoiceNotePlayButton(url: MemoryMediaStore.url(for: filename))
                }
            }
            Spacer()
            if let photo = MemoryMediaStore.photoImage(event.photoFilename) {
                photo
                    .resizable()
                    .scaledToFill()
                    .frame(width: 52, height: 52)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .strokeBorder(Theme.faded, lineWidth: 1)
                    )
                    .accessibilityLabel("Photo attached to \(event.title)")
            }
            Image(systemName: "chevron.right")
                .font(AppFont.serif(.caption))
                .foregroundStyle(Theme.faded)
        }
        .padding(12)
        .paperCard()
    }

    static func subtitle(for event: LifeEvent, birthDate: Date) -> String {
        let date = MonthsGrid.date(forMonthIndex: event.monthIndex, birthDate: birthDate, calendar: .current)
        let age = event.monthIndex / 12
        let formatted = date.formatted(.dateTime.month(.wide).year())
        return age == 0 ? formatted : "Age \(age) · \(formatted)"
    }
}

/// A tiny, tappable play/stop control for a memory's voice note. Owns its
/// own playback session so multiple rows can each play independently.
struct VoiceNotePlayButton: View {
    let url: URL

    @State private var session = VoiceNoteSession()

    var body: some View {
        Button {
            session.togglePlayback(of: url)
        } label: {
            Label(session.isPlaying ? "Stop" : "Play voice note",
                  systemImage: session.isPlaying ? "stop.circle.fill" : "play.circle")
                .font(AppFont.serif(.caption))
                .foregroundStyle(Theme.dustyBlue)
        }
        .buttonStyle(.borderless)
    }
}

#Preview {
    NavigationStack { LifeGridView() }
        .environment(AppModel())
        .fontDesign(.serif)
        .tint(Theme.dustyBlue)
}
