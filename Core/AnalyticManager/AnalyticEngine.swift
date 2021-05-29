import Foundation

public protocol AnalyticsEngine: class {
    func sendAnalyticsEvent(named name: String, parameters: [String: String])
}
