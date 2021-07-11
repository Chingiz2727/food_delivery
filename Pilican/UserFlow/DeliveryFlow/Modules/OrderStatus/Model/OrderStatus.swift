import UIKit

enum OrderStatus: Int, CaseIterable {
    case onFetching = 2
    case onPreparing = 3
    case onDelivery = 4
    case finished = 5
    case received = 6
    
    var title: String {
        switch self {
        case .onFetching:
            return "Заказ обрабатывается"
        case .onPreparing:
            return "Заказ готовится"
        case .onDelivery:
            return "Заказ отправлен"
        case .finished:
            return "На доставке"
        case .received:
            return ""
        }
    }
    
    var onStatusImage: UIImage? {
        switch self {
        case .onFetching:
            return Images.orderAccepted.image
        case .onPreparing:
            return Images.orderCooking.image
        case .onDelivery:
            return Images.orderSent.image
        case .finished:
            return Images.orderDelivered.image
        case .received:
            return UIImage()
        }
    }
    
    var disabledImage: UIImage? {
        switch self {
        case .onFetching:
            return Images.orderAccepted.image
        case .onPreparing:
            return Images.cooking.image
        case .onDelivery:
            return Images.sent.image
        case .finished:
            return Images.delivered.image
        case .received:
            return UIImage()
        }
    }
}

enum OrderPassStatus {
    case disabled
    case onProgress
    case onPassed
}
