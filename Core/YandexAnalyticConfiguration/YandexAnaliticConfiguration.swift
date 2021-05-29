import YandexMobileMetrica

final class YandexAnalyticsEngine: AnalyticsEngine {
    func sendAnalyticsEvent(named name: String, parameters: [String: String]) {
        YMMYandexMetrica.reportEvent(name, parameters: parameters) { error in
            print("Analytic Error")
            print(error)
        }
    }
}
