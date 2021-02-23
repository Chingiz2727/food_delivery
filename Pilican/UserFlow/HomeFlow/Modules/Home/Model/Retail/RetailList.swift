import RxDataSources

struct RetailList: Codable {
    let retailList: [Retail]
    let totalElements: Int
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
