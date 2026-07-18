import SwiftUI

/// Shared rounded watercolor artwork banner used at the top of tabs, with a
/// slow Ken Burns drift so the paintings feel alive rather than static.
struct ArtHeader: View {
    let imageName: String
    let label: String

    @State private var drifting = false

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .scaleEffect(drifting ? 1.07 : 1.0, anchor: .center)
            .frame(maxWidth: .infinity)
            .frame(height: 180)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(Theme.faded, lineWidth: 1)
            )
            .accessibilityLabel(label)
            .onAppear {
                withAnimation(.easeInOut(duration: 14).repeatForever(autoreverses: true)) {
                    drifting = true
                }
            }
    }
}
