import Foundation
import Observation
import LifeMetricsKit
import MLXLMCommon

/// Runs an open-source LLM fully on-device via MLX to write reflections
/// on the user's numbers. The model weights are downloaded from the
/// Hugging Face hub on first use and cached locally; after that the
/// feature works entirely offline. No server, no API key.
@Observable
@MainActor
final class ReflectionEngine {
    enum Phase: Equatable {
        case idle
        case loadingModel(progress: Double?)
        case generating
        case failed(String)
    }

    private(set) var phase: Phase = .idle

    private var session: ChatSession?
    private var loadedModelID: String?

    /// Whether this hardware can run MLX at all (Apple silicon only).
    static var isSupported: Bool {
        #if targetEnvironment(simulator)
        return false
        #elseif arch(arm64)
        return true
        #else
        return false
        #endif
    }

    /// Generates a reflection, loading (and on first run downloading) the
    /// model if needed. Returns the generated text, or nil on failure with
    /// `phase` set to `.failed`.
    func generate(modelID: String, prompt: String) async -> String? {
        do {
            if session == nil || loadedModelID != modelID {
                phase = .loadingModel(progress: nil)
                let model = try await loadModel(id: modelID) { [weak self] progress in
                    Task { @MainActor in
                        self?.phase = .loadingModel(progress: progress.fractionCompleted)
                    }
                }
                session = ChatSession(model)
                loadedModelID = modelID
            }
            phase = .generating
            let raw = try await session!.respond(to: prompt)
            phase = .idle
            return ReflectionPrompt.stripThinking(from: raw)
        } catch {
            phase = .failed(error.localizedDescription)
            return nil
        }
    }
}
