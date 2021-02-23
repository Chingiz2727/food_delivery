struct Retail: Codable {
    let id: Int
    let name: String
    let address: String
    let cashBack: Int
    let dlvCashBack: Int
    let latitude: Double
    let longitude: Double
    let logo: String
    let payIsWork: Int
    var imgLogo: String? {
        return "https://st.pillikan.kz/retail/logo\(logo)"
    }
}
