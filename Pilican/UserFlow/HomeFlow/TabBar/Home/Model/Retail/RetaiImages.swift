struct RetailImages: Codable {
    let path: String
    var imgUrl: String? {
        return "https://st.pillikan.kz/retail/logo\(path)"
    }
}
