import SwiftUI
import PhotosUI
import LifeMetricsKit

/// Add or edit one month's memory. Built to need no typing at all:
/// pick an icon, tap a suggestion, done. Text fields, a photo, and a
/// 30-second voice note are optional extras.
struct MemoryEditorView: View {
    let selection: MonthSelection
    let monthsLived: Int

    @Environment(AppModel.self) private var model
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var symbolName = "star"
    @State private var note = ""
    @State private var monthIndex = 0

    // Media is staged here and only committed on save.
    @State private var photoData: Data?
    @State private var photoChanged = false
    @State private var pickedPhoto: PhotosPickerItem?
    @State private var audioRemoved = false
    @State private var voice = VoiceNoteSession()

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

                    photoSection

                    voiceSection

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
            if let filename = selection.event?.photoFilename {
                photoData = try? Data(contentsOf: MemoryMediaStore.url(for: filename))
            }
        }
        .onDisappear {
            voice.stopPlayback()
            voice.stopRecording()
            voice.discardStagedRecording()
        }
        .onChange(of: pickedPhoto) { _, item in
            guard let item else { return }
            Task {
                if let data = try? await item.loadTransferable(type: Data.self) {
                    photoData = data
                    photoChanged = true
                }
            }
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
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 4), spacing: 10) {
            ForEach(Self.icons, id: \.self) { icon in
                Button {
                    symbolName = icon
                } label: {
                    MemoryIconView(symbolName: icon)
                        .frame(height: 76)
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Theme.sage.opacity(0.4)))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(symbolName == icon ? Theme.dustyBlue : Theme.faded,
                                              lineWidth: symbolName == icon ? 3 : 1)
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

    // MARK: - Photo

    private var photoSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("A photo (optional)")
                .font(AppFont.serif(.caption))
                .foregroundStyle(Theme.inkSecondary)
            if let photoData, let image = MemoryMediaStore.image(from: photoData) {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .strokeBorder(Theme.faded, lineWidth: 1)
                    )
            }
            HStack {
                PhotosPicker(selection: $pickedPhoto, matching: .images) {
                    Label(photoData == nil ? "Add from Photos" : "Change photo",
                          systemImage: "photo.on.rectangle.angled")
                        .font(AppFont.serif(.subheadline))
                }
                .buttonStyle(.bordered)
                if photoData != nil {
                    Button(role: .destructive) {
                        photoData = nil
                        pickedPhoto = nil
                        photoChanged = true
                    } label: {
                        Label("Remove", systemImage: "trash")
                            .font(AppFont.serif(.subheadline))
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
    }

    // MARK: - Voice note

    /// URL of whatever voice note there is to play: a fresh recording, or
    /// the one saved with the memory.
    private var playableAudioURL: URL? {
        if let staged = voice.stagedRecordingURL { return staged }
        if audioRemoved { return nil }
        return selection.event?.audioFilename.map(MemoryMediaStore.url(for:))
    }

    private var voiceSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("A voice note — up to 30 seconds (optional)")
                .font(AppFont.serif(.caption))
                .foregroundStyle(Theme.inkSecondary)
            HStack(spacing: 8) {
                if voice.isRecording {
                    Button {
                        voice.stopRecording()
                    } label: {
                        Label("Stop", systemImage: "stop.circle.fill")
                            .font(AppFont.serif(.subheadline))
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Theme.terracotta)
                    Text(timerInterval: voice.recordingWindow, countsDown: true)
                        .font(AppFont.serif(.subheadline).monospacedDigit())
                        .foregroundStyle(Theme.terracotta)
                } else {
                    Button {
                        Task { await voice.startRecording() }
                    } label: {
                        Label(playableAudioURL == nil ? "Record" : "Re-record",
                              systemImage: "mic.fill")
                            .font(AppFont.serif(.subheadline))
                    }
                    .buttonStyle(.bordered)
                    if let url = playableAudioURL {
                        Button {
                            voice.togglePlayback(of: url)
                        } label: {
                            Label(voice.isPlaying ? "Stop" : "Play",
                                  systemImage: voice.isPlaying ? "stop.fill" : "play.fill")
                                .font(AppFont.serif(.subheadline))
                        }
                        .buttonStyle(.bordered)
                        Button(role: .destructive) {
                            voice.stopPlayback()
                            voice.discardStagedRecording()
                            audioRemoved = true
                        } label: {
                            Label("Remove", systemImage: "trash")
                                .font(AppFont.serif(.subheadline))
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
            if voice.microphoneDenied {
                Text("Microphone access is off for this app — enable it in System Settings › Privacy & Security to record.")
                    .font(AppFont.serif(.caption))
                    .foregroundStyle(Theme.terracotta)
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

            // Commit staged media, replacing (and cleaning up) what it displaces.
            var photoFilename = selection.event?.photoFilename
            if photoChanged {
                MemoryMediaStore.delete(selection.event?.photoFilename)
                photoFilename = photoData.flatMap(MemoryMediaStore.savePhoto)
            }
            var audioFilename = selection.event?.audioFilename
            if let staged = voice.stagedRecordingURL {
                voice.stopPlayback()
                MemoryMediaStore.delete(selection.event?.audioFilename)
                audioFilename = MemoryMediaStore.saveAudio(from: staged)
            } else if audioRemoved {
                MemoryMediaStore.delete(selection.event?.audioFilename)
                audioFilename = nil
            }

            let event = LifeEvent(
                id: selection.event?.id ?? UUID(),
                monthIndex: monthIndex,
                title: resolvedTitle.isEmpty ? "A memory" : resolvedTitle,
                symbolName: symbolName,
                note: note.trimmingCharacters(in: .whitespaces).isEmpty ? nil : note,
                photoFilename: photoFilename,
                audioFilename: audioFilename
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
