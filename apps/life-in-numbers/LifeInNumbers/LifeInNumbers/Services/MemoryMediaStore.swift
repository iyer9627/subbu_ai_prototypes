import Foundation
import SwiftUI
#if os(macOS)
import AppKit
#else
import UIKit
#endif

/// Photos and voice notes attached to memories, stored as plain files in
/// Application Support. Events persist only filenames — UserDefaults never
/// holds binary data. Everything stays on device.
enum MemoryMediaStore {
    static var directory: URL {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        let dir = base.appendingPathComponent("MemoryMedia", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }

    static func url(for filename: String) -> URL {
        directory.appendingPathComponent(filename)
    }

    /// Writes picked photo data to the store; returns the new filename.
    static func savePhoto(_ data: Data) -> String? {
        let name = UUID().uuidString + ".jpg"
        do {
            try data.write(to: url(for: name))
            return name
        } catch {
            return nil
        }
    }

    /// Moves a finished voice-note recording into the store; returns the
    /// new filename.
    static func saveAudio(from tempURL: URL) -> String? {
        let name = UUID().uuidString + ".m4a"
        do {
            try FileManager.default.moveItem(at: tempURL, to: url(for: name))
            return name
        } catch {
            return nil
        }
    }

    static func delete(_ filename: String?) {
        guard let filename else { return }
        try? FileManager.default.removeItem(at: url(for: filename))
    }

    /// The stored photo as a SwiftUI image, or nil if missing.
    static func photoImage(_ filename: String?) -> Image? {
        guard let filename, let data = try? Data(contentsOf: url(for: filename)) else { return nil }
        return image(from: data)
    }

    /// Decodes raw picked data (JPEG/PNG/HEIC) into a SwiftUI image.
    static func image(from data: Data) -> Image? {
        #if os(macOS)
        NSImage(data: data).map(Image.init(nsImage:))
        #else
        UIImage(data: data).map(Image.init(uiImage:))
        #endif
    }
}
