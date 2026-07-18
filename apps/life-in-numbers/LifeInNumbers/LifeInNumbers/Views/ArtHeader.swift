import SwiftUI

/// Shared rounded watercolor artwork banner used at the top of tabs.
struct ArtHeader: View {
    let imageName: String
    let label: String

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity)
            .frame(height: 180)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(Theme.faded, lineWidth: 1)
            )
            .accessibilityLabel(label)
    }
}
