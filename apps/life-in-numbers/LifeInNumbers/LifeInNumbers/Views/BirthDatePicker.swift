import SwiftUI

/// Year/month menus above a graphical calendar — jumping decades on a
/// scrolling wheel is painful, so let people pick the year and month first.
struct BirthDatePicker: View {
    @Binding var date: Date

    private static let calendar = Calendar.current
    private static let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL"
        return formatter
    }()

    private var years: [Int] {
        let currentYear = Self.calendar.component(.year, from: .now)
        return Array((1900...currentYear).reversed())
    }

    private var months: [Int] { Array(1...12) }

    private var year: Int { Self.calendar.component(.year, from: date) }
    private var month: Int { Self.calendar.component(.month, from: date) }

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Picker("Month", selection: Binding(
                    get: { month },
                    set: { setDate(year: year, month: $0) }
                )) {
                    ForEach(months, id: \.self) { month in
                        Text(monthName(month)).tag(month)
                    }
                }
                Picker("Year", selection: Binding(
                    get: { year },
                    set: { setDate(year: $0, month: month) }
                )) {
                    ForEach(years, id: \.self) { year in
                        Text(String(year)).tag(year)
                    }
                }
            }

            DatePicker(
                "Birth date",
                selection: $date,
                in: ...Date.now,
                displayedComponents: .date
            )
            .labelsHidden()
            .datePickerStyle(.graphical)
        }
    }

    private func monthName(_ month: Int) -> String {
        var components = DateComponents()
        components.month = month
        components.year = 2000
        components.day = 1
        let referenceDate = Self.calendar.date(from: components) ?? .now
        return Self.monthFormatter.string(from: referenceDate)
    }

    /// Rebuilds the date, clamping the day to the target month's valid range
    /// (e.g. Jan 31 → Feb 28) and the result to not exceed today.
    private func setDate(year: Int, month: Int) {
        let calendar = Self.calendar
        let day = calendar.component(.day, from: date)

        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        guard let firstOfMonth = calendar.date(from: components) else { return }
        let range = calendar.range(of: .day, in: .month, for: firstOfMonth) ?? Range(1...28)
        components.day = min(day, range.upperBound - 1)

        guard let newDate = calendar.date(from: components) else { return }
        date = min(newDate, .now)
    }
}
