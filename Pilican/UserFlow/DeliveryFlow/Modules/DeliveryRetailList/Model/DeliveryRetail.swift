struct DeliveryRetail: Codable, RetailAdapter {
    var retailId: Int? {
        id
    }
    
    var retailName: String? {
        name
    }
    
    var retailImgUrl: String? {
        imgLogo
    }
    
    var retailRating: Double? {
        rating
    }
    
    var retailStatus: Int? {
        status
    }
    
    var retailAdress: String? {
        address
    }
    
    var id: Int
    let cashBack, isWork: Int
    let longitude, latitude: Double
    let dlvCashBack, pillikanDelivery: Int
    let logo, address: String
    let workDays: [WorkDay]
    let payIsWork: Int
    let name: String
    let status: Int
    let rating: Double?
    var imgLogo: String? {
        return "https://st.pillikan.kz/retail/logo\(logo)"
    }
}
