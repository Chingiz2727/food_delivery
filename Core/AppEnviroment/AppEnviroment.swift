import Foundation

public enum AppEnviroment {
    
    public static let isDebug: Bool = {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }()
    
    public static let bundleIdentifier = Bundle.main.bundleIdentifier ?? ""

    public static let baseURL: String = {
        guard let baseURL = AppEnviroment.infoDictionary["base_url"] as? String else {
            fatalError("baseURL not found")
        }
        return baseURL
    }()
    
    private static let infoDictionary: [String: Any] = {
        guard let infoDictionary = Bundle.main.infoDictionary else {
            fatalError("Info.plist file not found")
        }
        return infoDictionary
    }()
    
    public static let appVersion: String = {
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            fatalError("appVersion not found")
        }
        return appVersion
    }()
}
