import MapKit
import SwiftUI

/// Wraps MKLocalSearchCompleter to suggest cities for "Place of birth" fields.
@Observable
@MainActor
final class CityAutocomplete: NSObject {
    private(set) var suggestions: [String] = []

    @ObservationIgnored
    private let completer = MKLocalSearchCompleter()

    override init() {
        super.init()
        completer.delegate = self
        completer.resultTypes = .address
    }

    /// Clears suggestions below two characters to avoid noisy single-letter results.
    func update(query: String) {
        guard query.count >= 2 else {
            suggestions = []
            return
        }
        completer.queryFragment = query
    }

    func clear() {
        suggestions = []
        completer.queryFragment = ""
    }
}

extension CityAutocomplete: MKLocalSearchCompleterDelegate {
    nonisolated func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let formatted = completer.results.map { result in
            result.subtitle.isEmpty ? result.title : "\(result.title), \(result.subtitle)"
        }
        var seen = Set<String>()
        let deduplicated = formatted.filter { seen.insert($0).inserted }.prefix(5)
        let top5 = Array(deduplicated)
        Task { @MainActor in
            self.suggestions = top5
        }
    }

    nonisolated func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        Task { @MainActor in
            self.suggestions = []
        }
    }
}
