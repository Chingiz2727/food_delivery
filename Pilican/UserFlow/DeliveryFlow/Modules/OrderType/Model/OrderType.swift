enum OrderType: CaseIterable {
    case delivery
    case takeAway
    case onRestaurant
    
    var title: String {
        switch self {
        case .delivery:
            return "Доставка Pillikan"
        case .takeAway:
            return "Заберу навынос"
        case .onRestaurant:
            return "На месте"
        }
    }
    
    var description: String {
        switch self {
        case .delivery:
            return "Доставка через 55 мин."
        case .takeAway:
            return "С собой через 15-20 мин."
        case .onRestaurant:
            return "Недоступно"
        }
    }
    
    var img: UIImage? {
        switch self {
        case .delivery:
            return Images.deliveryType.image
        case .takeAway:
            return Images.takeAway.image
        case .onRestaurant:
            return Images.inPlace.image
        }
    }
}
