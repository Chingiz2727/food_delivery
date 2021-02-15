#if DEBUG
import Foundation

enum Apis: Int, CaseIterable {
    case test
    case dev
    case prod

    var urlString: String {
        switch self {
        case .dev:
            return "https://api.pillikan.org.kz/api"
        case .test:
            return "https://api.pillikan.org.kz/api"
        case .prod:
            return "https://api.pillikan.kz/api"
        }
    }

    private static var key: String {
        "apiChangedURL"
    }

    static var currentSelected: Apis {
        get {
            Apis(rawValue: UserDefaults.standard.integer(forKey: Apis.key)) ?? .test
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: Apis.key)
            UserDefaults.standard.synchronize()
        }
    }
}
#endif
