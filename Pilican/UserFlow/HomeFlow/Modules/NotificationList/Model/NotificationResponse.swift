struct NotificationResponse: Codable, Pagination {
    var totalElements: Int?
    var hasNext: Bool?
    let status: Int
    let list: [NotificationInfo]
    let totalCount: Int
    var items: [NotificationInfo] {
        return list
    }
}

struct NotificationInfo: Codable {
    let id: Int
    let title: String
    let description: String
    let createdAt: String
}
