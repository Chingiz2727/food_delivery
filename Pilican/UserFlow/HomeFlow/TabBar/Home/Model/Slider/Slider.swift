struct Sliders: Codable {
    let sliders: [Slider]
}

struct Slider: Codable {
    let title: String
    let image: String
    let url: String
    let retailId: Int
    let type: Int

    var imgLogo: String {
        return "https://st.pillikan.kz/slider/\(image)"
    }
}

enum SliderType: String {
    case delivery = "Доставка"
    case infoDelivery = "Инфо доставка"
    case friend = "Пригласи друга"
    case cashback = "Кэшбэк"
    case deliverySecond = "Доставка куда угодно"
}
