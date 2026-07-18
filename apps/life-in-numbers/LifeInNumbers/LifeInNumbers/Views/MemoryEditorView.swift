import SwiftUI
import LifeMetricsKit

/// Add or edit one month's memory. Built to need no typing at all:
/// pick an icon, tap a suggestion, done. Text fields are optional extras.
struct MemoryEditorView: View {
    let selection: MonthSelection
    let monthsLived: Int

    @Environment(AppModel.self) private var model
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var symbolName = "star"
    @State private var note = ""
    @State private var monthIndex = 0

    /// Icon choices, large and universal.
    private static let icons = [
        "sun.max", "figure.walk", "backpack", "graduationcap",
        "heart", "briefcase", "house", "airplane",
        "music.note", "pawprint", "trophy", "gift",
    ]

    /// One-tap memory suggestions; each sets a title and matching icon.
    private static let suggestions: [(title: String, symbol: String)] = [
        ("Started school", "backpack"),
        ("Graduated", "graduationcap"),
        ("First crush", "heart"),
        ("First job", "briefcase"),
        ("Moved home", "house"),
        ("A big trip", "airplane"),
        ("New pet", "pawprint"),
        ("Proud moment", "trophy"),
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header

                    iconPicker

                    suggestionChips

                    VStack(alignment: .leading, spacing: 6) {
                        Text("In my words (optional)")
                            .font(AppFont.serif(.caption))
                            .foregroundStyle(Theme.inkSecondary)
                        TextField("What happened?", text: $title)
                            .textFieldStyle(.roundedBorder)
                        TextField("A note to remember (optional)", text: $note)
                            .textFieldStyle(.roundedBorder)
                    }

                    monthPicker

                    saveButton

                    if selection.event != nil {
                        Button(role: .destructive) {
                            if let id = selection.event?.id {
                                model.deleteEvent(id: id)
                            }
                            dismiss()
                        } label: {
                            Label("Remove this memory", systemImage: "trash")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .padding()
            }
            .background(Theme.paper)
            .navigationTitle(selection.event == nil ? "New Memory" : "Edit Memory")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
        .onAppear {
            title = selection.event?.title ?? ""
            symbolName = selection.event?.symbolName ?? "star"
            note = selection.event?.note ?? ""
            monthIndex = selection.monthIndex
        }
        #if os(macOS)
        .frame(minWidth: 460, minHeight: 560)
        #endif
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(monthLabel(for: monthIndex))
                .font(AppFont.serif(.title2, .semibold))
                .foregroundStyle(Theme.ink)
            Text("A month of your life. What do you remember?")
                .font(AppFont.serif(.subheadline))
                .foregroundStyle(Theme.inkSecondary)
        }
    }

    private var iconPicker: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 6), spacing: 10) {
            ForEach(Self.icons, id: \.self) { icon in
                Button {
                    symbolName = icon
                } label: {
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundStyle(symbolName == icon ? .white : Theme.ink)
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(symbolName == icon ? Theme.sage : Theme.card)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(symbolName == icon ? Theme.sage : Theme.faded, lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
                .accessibilityLabel(icon)
                .accessibilityAddTraits(symbolName == icon ? .isSelected : [])
            }
        }
    }

    private var suggestionChips: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: 8)], spacing: 8) {
            ForEach(Self.suggestions, id: \.title) { suggestion in
                Button {
                    title = suggestion.title
                    symbolName = suggestion.symbol
                } label: {
                    Text(suggestion.title)
                        .font(AppFont.serif(.subheadline))
                        .lineLimit(1)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Capsule().fill(title == suggestion.title ? Theme.terracotta.opacity(0.2) : Theme.card))
                        .overlay(Capsule().strokeBorder(Theme.faded, lineWidth: 1))
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var monthPicker: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("When was it?")
                .font(AppFont.serif(.caption))
                .foregroundStyle(Theme.inkSecondary)
            HStack {
                Button {
                    monthIndex = max(0, monthIndex - 1)
                } label: {
                    Image(systemName: "chevron.left").frame(minWidth: 44, minHeight: 36)
                }
                .buttonStyle(.bordered)
                .disabled(monthIndex == 0)

                Text(monthLabel(for: monthIndex))
                    .font(AppFont.serif(.headline, .semibold))
                    .foregroundStyle(Theme.ink)
                    .frame(maxWidth: .infinity)
                    .contentTransition(.numericText())

                Button {
                    monthIndex = min(monthsLived, monthIndex + 1)
                } label: {
                    Image(systemName: "chevron.right").frame(minWidth: 44, minHeight: 36)
                }
                .buttonStyle(.bordered)
                .disabled(monthIndex >= monthsLived)
            }
        }
    }

    private var saveButton: some View {
        Button {
            let resolvedTitle = title.trimmingCharacters(in: .whitespaces)
            let event = LifeEvent(
                id: selection.event?.id ?? UUID(),
                monthIndex: monthIndex,
                title: resolvedTitle.isEmpty ? "A memory" : resolvedTitle,
                symbolName: symbolName,
                note: note.trimmingCharacters(in: .whitespaces).isEmpty ? nil : note
            )
            model.upsert(event)
            dismiss()
        } label: {
            Label("Keep this memory", systemImage: "checkmark")
                .font(AppFont.serif(.headline, .semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
        }
        .buttonStyle(.borderedProminent)
    }

    private func monthLabel(for index: Int) -> String {
        let date = MonthsGrid.date(forMonthIndex: index, birthDate: model.profile.birthDate, calendar: .current)
        let age = index / 12
        let formatted = date.formatted(.dateTime.month(.wide).year())
        return age == 0 ? formatted : "Age \(age) · \(formatted)"
    }
}
