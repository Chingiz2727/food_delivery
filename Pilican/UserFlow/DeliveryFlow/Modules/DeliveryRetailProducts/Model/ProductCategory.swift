import RxDataSources

struct ProductCategory: Codable, SectionModelType {
    let id: Int
    let dishes: [Product]
    let name: String
    let age_access: Int
    var items: [Product] {
        dishes
    }

    init(original: ProductCategory, items: [Product]) {
        self = original
    }
}
