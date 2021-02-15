public protocol IdPagination {
  associatedtype IdType
  associatedtype Content

  var items: [Content] { get }
  var lastElementId: IdType? { get }
  var isLast: Bool { get }
}

public extension IdPagination {
  var isLast: Bool { items.isEmpty }
}
