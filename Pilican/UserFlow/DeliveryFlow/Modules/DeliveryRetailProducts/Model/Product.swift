struct Product: Codable {
    let status: Int
    let img: String
    let id, price: Int
    let composition: String
    let age_access: Int
    let name: String
    var shoppingCount: Int?
}
