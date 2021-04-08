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
    let facebook: String?
    let whatsappUrl: String?
    let telegram: String?
    let youtube: String?
    let instagram: String?
    let webUrl: String?
    let vk: String?
    let phone: String?
    let workDays: [WorkDay]
    let images: [RetailImages]?
    let avgAmount: String?

    var imgLogo: String? {
        return "https://st.pillikan.kz/retail/logo\(logo)"
    }
    var networkList: [SocialNetwork] {
        var list = [SocialNetwork]()
        list.append(.facebook(facebook ?? ""))
        list.append(.whatsappUrl(whatsappUrl ?? ""))
        list.append(.telegram(telegram ?? ""))
        list.append(.youtube(youtube ?? ""))
        list.append(.instagram(instagram ?? ""))
        list.append(.webUrl(webUrl ?? ""))
        list.append(.vk(vk ?? ""))
        list.append(.phone(phone ?? ""))
        return list
    }

    let wifi: Int?
    let rating: Double?
    let cash: Int?
    let booking: Int?
    let isPayable: Int?
    let isVisible: Int?
    let kaspi: Int?
    let card: Int?
    let delivery: Int?
    let description: String?

    var paymentOptions: [String] {
        var options: [String] = []
        if card == 1 {
            options.append("Расчёт по картам")
        }; if cash == 1 {
            options.append("Наличный расчёт")
        }; if kaspi == 1 {
            options.append("Оплата Kaspi Red")
        }
        return options
    }

    var additionalOptions: [String] {
        var options: [String] = []
        if wifi == 1 {
            options.append("Wi-Fi")
        }; if delivery == 1 {
            options.append("Доставка")
        }; if booking == 1 {
            options.append("Бронь")
        }
        return options
    }
}
