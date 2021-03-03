
import Foundation

public enum AppLanguage: String, CaseIterable {
    case ru
    case kk
}

public extension AppLanguage {
    static let `default` = AppLanguage.ru

    var locale: Locale {
        Locale(identifier: rawValue)
    }
}

public extension AppLanguage {
    static var preferredLanguages: [String] {
        [current.rawValue]
    }

    static var current: AppLanguage {
        get { getCurrentLanguage() }
        set { _current = newValue }
    }

    @UserDefaultsOptionalEnumEntry("appLanguage")

    private static var _current: AppLanguage?

    private static func getCurrentLanguage() -> AppLanguage {
        if let appLanguage = _current {
            return appLanguage
        } else {
            if let rawValue = Bundle.main.preferredLocalizations.first ?? Locale.current.languageCode,
                let appLanguage = AppLanguage(rawValue: rawValue) {
                return appLanguage
            } else {
                return .default
            }
        }
    }
}

public extension AppLanguage {
    var title: String {
        switch self {
        case .kk:
            return "Қазақ"
        case .ru:
            return "Русский"
        }
    }

    var isCurrentLanguage: Bool {
        AppLanguage.current == self
    }
}
