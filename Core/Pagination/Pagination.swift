public protocol Pagination: Codable {
    
    associatedtype Content: Codable
    var totalElements: Int { get }
    var items: [Content] { get }
}

