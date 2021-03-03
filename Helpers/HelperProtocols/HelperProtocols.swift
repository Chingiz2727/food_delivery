import Foundation

protocol Rangeable: AnyObject {
    var range: NSRange { get set }
}

protocol Identifiable {
    var rawValue: String { get }
}

extension Identifiable {
    var id: String { String(describing: Self.self) + rawValue }
}
