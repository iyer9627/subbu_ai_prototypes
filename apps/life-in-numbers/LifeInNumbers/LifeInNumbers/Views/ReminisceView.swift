import SwiftUI
import LifeMetricsKit

/// "Reminisce": brings one kept memory back as a scrapbook page — the
/// watercolor icon, the words, and any photos rendered like pasted-in
/// polaroids. Lives on the Reflection tab and needs no model at all;
/// the material is the user's own diary.
struct ReminisceSection: View {
    @Environment(AppModel.self) private var model
    @State private var current: LifeEvent?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Reminisce")
                    .font(AppFont.serif(.title2, .semibold))
                    .foregroundStyle(Theme.ink)
                Text("One kept moment, brought back for a minute.")
                    .font(AppFont.serif(.subheadline))
                    .foregroundStyle(Theme.inkSecondary)
            }

            if model.events.isEmpty {
                Text("Your diary is empty so far — tap a month in Life in Months to keep your first memory, then come back here.")
                    .font(AppFont.serif(.subheadline))
                    .foregroundStyle(Theme.inkSecondary)
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .paperCard()
            } else {
                if let memory = current {
                    ReminisceCard(
                        event: memory,
                        birthDate: model.profile.birthDate,
                        otherPhotoMemories: otherPhotoMemories(than: memory)
                    )
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                    .id(memory.id)
                }
                Button {
                    withAnimation(.spring(duration: 0.5)) { current = pick() }
                } label: {
                    Label(current == nil ? "Reminisce" : "Another moment",
                          systemImage: "book.pages")
                        .font(AppFont.serif(.headline, .semibold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }

    /// A memory other than the current one, leaning toward those with
    /// photos — a picture is what makes the page.
    private func pick() -> LifeEvent? {
        let candidates = model.events.filter { $0.id != current?.id }
        guard !candidates.isEmpty else { return current }
        return candidates.filter { $0.photoFilename != nil }.randomElement()
            ?? candidates.randomElement()
    }

    /// Up to two more photos from other memories, to fill the album row.
    private func otherPhotoMemories(than memory: LifeEvent) -> [LifeEvent] {
        Array(
            model.events
                .filter { $0.id != memory.id && $0.photoFilename != nil }
                .shuffled()
                .prefix(2)
        )
    }
}

struct ReminisceCard: View {
    let event: LifeEvent
    let birthDate: Date
    let otherPhotoMemories: [LifeEvent]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 12) {
                MemoryIconView(symbolName: event.symbolName)
                    .frame(width: 56, height: 56)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Theme.sage))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                VStack(alignment: .leading, spacing: 2) {
                    Text(event.title)
                        .font(AppFont.serif(.title3, .semibold))
                        .foregroundStyle(Theme.ink)
                    Text(MemoryRowView.subtitle(for: event, birthDate: birthDate))
                        .font(AppFont.serif(.caption))
                        .foregroundStyle(Theme.inkSecondary)
                }
            }

            if let photo = MemoryMediaStore.photoImage(event.photoFilename) {
                PolaroidView(image: photo, caption: nil, rotation: -1.5, height: 220)
                    .frame(maxWidth: .infinity)
            }

            if let note = event.note, !note.isEmpty {
                Text("“\(note)”")
                    .font(AppFont.serifItalic(.body))
                    .foregroundStyle(Theme.ink)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if !otherPhotoMemories.isEmpty {
                Text("Also in your album")
                    .font(AppFont.serif(.caption))
                    .foregroundStyle(Theme.inkSecondary)
                HStack(alignment: .top, spacing: 16) {
                    ForEach(Array(otherPhotoMemories.enumerated()), id: \.element.id) { index, other in
                        if let photo = MemoryMediaStore.photoImage(other.photoFilename) {
                            PolaroidView(
                                image: photo,
                                caption: other.title,
                                rotation: index.isMultiple(of: 2) ? 2.5 : -2,
                                height: 110
                            )
                        }
                    }
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .paperCard()
    }
}

/// A photo rendered like a print pasted into a scrapbook: white border,
/// a soft shadow, and a slight tilt.
struct PolaroidView: View {
    let image: Image
    let caption: String?
    let rotation: Double
    let height: CGFloat

    var body: some View {
        VStack(spacing: 6) {
            image
                .resizable()
                .scaledToFill()
                .frame(height: height)
                .clipped()
            if let caption {
                Text(caption)
                    .font(AppFont.serif(.caption2))
                    .foregroundStyle(Color.black.opacity(0.65))
                    .lineLimit(1)
            }
        }
        .padding(8)
        .padding(.bottom, caption == nil ? 12 : 4)
        .background(Color.white)
        .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 3)
        .rotationEffect(.degrees(rotation))
        .accessibilityElement(children: .combine)
        .accessibilityLabel(caption ?? "A photo from this memory")
    }
}

#Preview {
    ScrollView {
        ReminisceSection()
            .padding()
    }
    .background(Theme.paper)
    .environment(AppModel())
    .fontDesign(.serif)
}
