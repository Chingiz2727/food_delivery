import Foundation

public protocol DateContent: Codable {

  var sectionDate: Date { get }
}

public struct DateSection<T> {
  public let date: Date
  public var content: [T]
}
