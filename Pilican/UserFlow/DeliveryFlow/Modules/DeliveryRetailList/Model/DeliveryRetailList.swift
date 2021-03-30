struct DeliveryRetailList: Codable, Pagination {
    let retails: DelivaryRetailContent
    let totalElements: Int?
    var hasNext: Bool? {
        retails.hasNext
    }
    var items: [DeliveryRetail] {
        retails.content
    }
}
