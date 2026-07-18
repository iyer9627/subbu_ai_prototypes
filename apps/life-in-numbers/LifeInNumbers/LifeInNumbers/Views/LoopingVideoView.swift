import SwiftUI
import AVFoundation

/// Silently loops a bundled video with no controls — used for the living
/// watercolor hero. Falls back to nothing if the resource is missing
/// (callers place a static image behind it).
struct LoopingVideoView {
    let resourceName: String

    static func makePlayer(resourceName: String) -> AVQueuePlayer? {
        guard let url = Bundle.main.url(forResource: resourceName, withExtension: "mp4") else { return nil }
        let player = AVQueuePlayer()
        player.isMuted = true
        let item = AVPlayerItem(url: url)
        // The looper must be retained for looping to continue.
        let looper = AVPlayerLooper(player: player, templateItem: item)
        objc_setAssociatedObject(player, &Self.looperKey, looper, .OBJC_ASSOCIATION_RETAIN)
        return player
    }

    private static var looperKey: UInt8 = 0
}

#if os(macOS)
extension LoopingVideoView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        if let player = Self.makePlayer(resourceName: resourceName) {
            let layer = AVPlayerLayer(player: player)
            layer.videoGravity = .resizeAspectFill
            // Order matters on AppKit: install the custom layer first, then
            // opt into layer backing, or the default backing layer wins and
            // the video never appears.
            view.layer = layer
            view.wantsLayer = true
            player.play()
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}
#else
extension LoopingVideoView: UIViewRepresentable {
    final class PlayerView: UIView {
        override static var layerClass: AnyClass { AVPlayerLayer.self }
    }

    func makeUIView(context: Context) -> PlayerView {
        let view = PlayerView()
        if let player = Self.makePlayer(resourceName: resourceName) {
            let layer = view.layer as? AVPlayerLayer
            layer?.player = player
            layer?.videoGravity = .resizeAspectFill
            player.play()
        }
        return view
    }

    func updateUIView(_ uiView: PlayerView, context: Context) {}
}
#endif
