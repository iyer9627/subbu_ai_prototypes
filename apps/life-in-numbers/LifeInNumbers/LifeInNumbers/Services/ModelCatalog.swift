import Foundation

/// Curated on-device models, filtered to what this hardware can actually
/// run. Users only ever see options that will work on their device.
struct ModelOption: Identifiable, Equatable {
    let id: String          // Hugging Face repo
    let name: String
    let subtitle: String
    /// Minimum physical memory (in GB) this model needs to run comfortably
    /// alongside the app and its KV cache.
    let minMemoryGB: Double

    var fits: Bool {
        Double(ProcessInfo.processInfo.physicalMemory) / 1_073_741_824 >= minMemoryGB
    }
}

enum ModelCatalog {
    static let all: [ModelOption] = [
        ModelOption(
            id: "mlx-community/Qwen2.5-0.5B-Instruct-4bit",
            name: "Fastest",
            subtitle: "Qwen 2.5 (0.5B) · ~300 MB · runs on every supported device",
            minMemoryGB: 0
        ),
        ModelOption(
            id: "mlx-community/Llama-3.2-1B-Instruct-4bit",
            name: "Balanced",
            subtitle: "Llama 3.2 (1B) · ~700 MB · noticeably better writing",
            minMemoryGB: 5.5
        ),
        ModelOption(
            id: "mlx-community/Qwen2.5-1.5B-Instruct-4bit",
            name: "Better writing",
            subtitle: "Qwen 2.5 (1.5B) · ~1 GB · needs a newer device",
            minMemoryGB: 7.0
        ),
        ModelOption(
            id: "mlx-community/Llama-3.2-3B-Instruct-4bit",
            name: "Best writing",
            subtitle: "Llama 3.2 (3B) · ~1.8 GB · newest iPhones and Macs",
            minMemoryGB: 7.5
        ),
        ModelOption(
            id: "mlx-community/Qwen2.5-7B-Instruct-4bit",
            name: "Studio",
            subtitle: "Qwen 2.5 (7B) · ~4.4 GB · Macs with 16 GB+",
            minMemoryGB: 15.0
        ),
    ]

    /// Only the options this device can run.
    static var available: [ModelOption] {
        all.filter(\.fits)
    }

    /// Default for new installs: the best-writing model the device can run,
    /// stopping short of the heavyweight Studio tier. The 0.5B floor model
    /// writes noticeably worse, so it's only the default when nothing bigger
    /// fits.
    static var recommended: ModelOption {
        available.last { $0.minMemoryGB < 10 } ?? all[0]
    }
}
