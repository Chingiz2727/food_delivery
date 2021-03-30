struct DeliveryRetail: Codable {
    let id, cashBack, isWork: Int
    let longitude, latitude: Double
    let dlvCashBack, pillikanDelivery: Int
    let logo, address: String
    let workDays: [WorkDay]
    let payIsWork: Int
    let name: String
    let status: Int
    var imgLogo: String? {
        return "https://st.pillikan.kz/retail/logo\(logo)"
    }
}
