import RxDataSources

struct RetailList: Codable, Pagination {
//    var totalPages: Int
    let retailList: [Retail]
    let totalElements: Int

    var items: [Retail] {
        retailList
    }
}

struct RetailSection: SectionModelType {
    var items: [Retail]

    init(items: [Retail]) {
        self.items = items
    }

    init(original: RetailSection, items: [Retail]) {
        self = original
        self.items = items
    }
}
