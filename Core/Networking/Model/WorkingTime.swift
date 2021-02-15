public struct WorkingTime: Codable {
  public let day: String
  public let time: String

  public init(day: String, time: String) {
    self.day = day
    self.time = time
  }
}

public extension Array where Element == WorkingTime {
  var schedule: String {
    map { $0.day + " " + $0.time }.joined(separator: "\n")
  }
}
