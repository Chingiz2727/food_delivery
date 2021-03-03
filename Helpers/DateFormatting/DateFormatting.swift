import Foundation

public enum DateFormattingType: String, Identifiable {
    case isoShortTimezone
    case isoLongTimezone
    case expiryDate
    case dayWithFullMonth
    case hourWithMinutes
    case dayWithMonth
    case fullMonthWithYear
    case year
    case fullDate
    case relative
    case shortMonth
    case shortDay
    // Используется только для того, чтобы кастомизировать `relativeDefault`
    case notRelative
}

public protocol DateFormatting {
    func string(from date: Date, type: DateFormattingType) -> String?
    func date(from string: String, type: DateFormattingType) -> Date?
}

extension PropertyFormatter: DateFormatting {
    private func cachedDateFormatter(with type: DateFormattingType) -> DateFormatter? {
        cachedFormattersQueue.sync {
            let key = type.id
            if let cachedFormatter = formatters[key] as? DateFormatter {
                return cachedFormatter
            }
            let dateFormatter = getDateFormatter(with: type)
            formatters[key] = dateFormatter

            return dateFormatter
        }
    }

    private func getDateFormatter(with type: DateFormattingType) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = appLanguage.locale
        switch type {
        case .isoLongTimezone:
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        case .isoShortTimezone:
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        case .expiryDate:
            dateFormatter.dateFormat = "dd.MM.yyyy"
        case .dayWithFullMonth:
            dateFormatter.dateFormat = "dd MMMM"
        case .hourWithMinutes:
            dateFormatter.dateFormat = "hh:mm"
        case .dayWithMonth:
            dateFormatter.dateFormat = "dd.MM"
        case .fullMonthWithYear:
            dateFormatter.dateFormat = "MMMM yyyy"
        case .fullDate:
            dateFormatter.dateFormat = "dd.MM.yyyy, hh:mm"
        case .shortMonth:
            dateFormatter.dateFormat = "MM"
        case .year:
            dateFormatter.dateFormat = "yyyy"
        case .relative:
            dateFormatter.dateStyle = .short
            dateFormatter.doesRelativeDateFormatting = true
        case .shortDay:
            dateFormatter.dateFormat = "dd"
        case .notRelative:
            dateFormatter.dateStyle = .short
            dateFormatter.doesRelativeDateFormatting = false
        }
        return dateFormatter
    }

    public func string(from date: Date, type: DateFormattingType) -> String? {
        if type == .relative {
            return handleRelativeFormatting(for: date)
        }
        let formatter: DateFormatter? = cachedDateFormatter(with: type)
        let string = formatter?.string(from: date)
        return string
    }

    private func handleRelativeFormatting(for date: Date) -> String? {
        let relativeFormatter = cachedDateFormatter(with: .relative)
        let notRelativeFormatter = cachedDateFormatter(with: .notRelative)
        let dayWithMonthFormatter = cachedDateFormatter(with: .dayWithMonth)

        let relative = relativeFormatter?.string(from: date)
        let notRelative = notRelativeFormatter?.string(from: date)
        let dayWithMonth = dayWithMonthFormatter?.string(from: date)

        // Это единственный способ форсить кастомный формат даты для relativeFormatter-a
        if relative == notRelative {
            return dayWithMonth
        } else {
            return relative
        }
    }

    public func date(from string: String, type: DateFormattingType) -> Date? {
        let formatter = cachedDateFormatter(with: type)
        let date = formatter?.date(from: string)
        return date
    }
}
