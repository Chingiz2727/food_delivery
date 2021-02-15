public protocol Pagination: Codable {

  associatedtype Content: Codable

  var totalPages: Int { get }
  var items: [Content] { get }
}

