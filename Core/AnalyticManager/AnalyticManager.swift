import Foundation

public protocol AnalyticsEvent {
    var name: String { get }
    var parameters: [String: String] { get }
}

open class AnalyticsManager {
    private let engine: AnalyticsEngine
    
    public init(engine: AnalyticsEngine) {
        self.engine = engine
    }
    
    public func log(_ event: AnalyticsEvent) {
        engine.sendAnalyticsEvent(named: event.name, parameters: event.parameters)
    }
}
