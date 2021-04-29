import UIKit

enum OrderStatus: Int, CaseIterable {
    case onFetching = 2
    case onPreparing = 3
    case onDelivery = 4
    case finished = 5
    
    var title: String {
        switch self {
        case .onFetching:
            return "Заказ обрабатывается"
        case .onPreparing:
            return "Заказ готовиться"
        case .onDelivery:
            return "Заказ отправлен"
        case .finished:
            return "На доставке"
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
        }
    }
}

enum OrderPassStatus {
    case disabled
    case onProgress
    case onPassed
}
