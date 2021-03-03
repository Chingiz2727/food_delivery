import Foundation

public final class PropertyFormatter {
    let appLanguage: AppLanguage
    var formatters: [String: Any] = [:]
    let cachedFormattersQueue = DispatchQueue(label: "team.alabs.formatter.queue")

    public init(appLanguage: AppLanguage) {
        self.appLanguage = appLanguage
    }
}
