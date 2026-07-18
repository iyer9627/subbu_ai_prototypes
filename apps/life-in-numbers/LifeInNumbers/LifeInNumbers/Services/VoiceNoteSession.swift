import Foundation
import Observation
import AVFoundation

/// Records and plays back one memory's voice note. Recording is capped at
/// 30 seconds — long enough to remember a moment, short enough to stay a
/// keepsake rather than a chore. Audio never leaves the device.
@Observable
@MainActor
final class VoiceNoteSession: NSObject {
    static let maxDuration: TimeInterval = 30

    private(set) var isRecording = false
    private(set) var isPlaying = false
    private(set) var microphoneDenied = false
    /// The countdown window of the recording in flight, for a live timer.
    private(set) var recordingWindow: ClosedRange<Date> = Date.now...Date.now
    /// A finished recording not yet committed to the media store.
    private(set) var stagedRecordingURL: URL?

    private var recorder: AVAudioRecorder?
    private var player: AVAudioPlayer?

    // MARK: - Recording

    func startRecording() async {
        guard await requestMicrophone() else {
            microphoneDenied = true
            return
        }
        microphoneDenied = false
        stopPlayback()
        discardStagedRecording()

        #if os(iOS)
        try? AVAudioSession.sharedInstance().setCategory(.playAndRecord, options: .defaultToSpeaker)
        try? AVAudioSession.sharedInstance().setActive(true)
        #endif

        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("voice-note-\(UUID().uuidString).m4a")
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44_100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue,
        ]
        do {
            let recorder = try AVAudioRecorder(url: tempURL, settings: settings)
            recorder.delegate = self
            recorder.record(forDuration: Self.maxDuration)
            self.recorder = recorder
            recordingWindow = Date.now...Date.now.addingTimeInterval(Self.maxDuration)
            isRecording = true
        } catch {
            isRecording = false
        }
    }

    func stopRecording() {
        recorder?.stop()
    }

    /// Plays either the staged recording or an already-saved voice note.
    func togglePlayback(of url: URL) {
        if isPlaying {
            stopPlayback()
            return
        }
        guard let player = try? AVAudioPlayer(contentsOf: url) else { return }
        player.delegate = self
        player.play()
        self.player = player
        isPlaying = true
    }

    func stopPlayback() {
        player?.stop()
        player = nil
        isPlaying = false
    }

    func discardStagedRecording() {
        if let url = stagedRecordingURL {
            try? FileManager.default.removeItem(at: url)
        }
        stagedRecordingURL = nil
    }

    private func requestMicrophone() async -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
        case .authorized: return true
        case .notDetermined: return await AVCaptureDevice.requestAccess(for: .audio)
        default: return false
        }
    }

    private func finishedRecording(successfully success: Bool) {
        let url = recorder?.url
        recorder = nil
        isRecording = false
        stagedRecordingURL = success ? url : nil
    }
}

extension VoiceNoteSession: AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    nonisolated func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        Task { @MainActor in self.finishedRecording(successfully: flag) }
    }

    nonisolated func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        Task { @MainActor in self.stopPlayback() }
    }
}
