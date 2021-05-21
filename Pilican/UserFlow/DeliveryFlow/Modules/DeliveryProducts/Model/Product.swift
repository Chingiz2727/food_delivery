struct Product: Codable {
    let status: Int
    let img: String?
    let id, price: Int
    let composition: String
    var age_access: Int
    let name: String
    var isExpanded: Bool? = false

    var shoppingCount: Int?
    var imgLogo: String? {
        return "https://st.pillikan.kz/delivery/\(img ?? "")"
    }
}
