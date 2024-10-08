import Foundation

enum MakeOrderTarget: ApiTarget {
    case deliveryDistance(km: Double)
    // swiftlint:disable line_length
    case makeOrder(addAmount: Int, address: String, contactless: Int, deliveryAmount: Int, description: String, foodAmount: Int, fullAmount: Int, latitude: Double, longitude: Double, orderItems: [Product], retailId: Int, type: Int, useCashback: Bool, utensils: Int, cardId: Int)
    case getFindOrderById(id: Int)
    case getActiveOrders
    
    var version: ApiVersion {
        return .custom("")
    }
    
    var servicePath: String {
        switch self {
        case .deliveryDistance:
            return "rates/delivery"
        case .makeOrder:
            return "a/cb/delivery/orders/create"
        case .getFindOrderById:
            return "a/cb/delivery/orders"
        case .getActiveOrders:
            return "a/cb/delivery/orders/active"
        }
    }
    
    var path: String {
        return ""
    }

    var method: HTTPMethod {
        switch self {
        case .deliveryDistance:
            return .get
        case .makeOrder:
            return .post
        case .getFindOrderById:
            return .get
        case .getActiveOrders:
            return .get
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case let.deliveryDistance(km):
            return ["kms": km]
        case let .makeOrder(addAmount, address, contactless, deliveryAmount, description, foodAmount, fullAmount, latitude, longitude, orderItems, retailId, type, useCashback, utensils, cardId):
            var orderData = [[String: Any]]()
            
            orderItems.forEach { p in
                var params = [String: Any]()
                params["dishId"] = p.id
                params["quantity"] = p.shoppingCount
                orderData.append(params)
            }
            return [
                "addAmount": addAmount,
                "address": address,
                "contactless": contactless,
                "deliveryAmount": deliveryAmount,
                "description": description,
                "foodAmount": foodAmount,
                "fullAmount": fullAmount,
                "latitude": latitude,
                "orderItems": orderData,
                "longitude": longitude,
                "retailId": retailId,
                "type": type,
                "useCashback": useCashback,
                "utensils": utensils,
                "cardId": cardId
            ]
        case .getFindOrderById(let id):
            return ["id": id]
        case .getActiveOrders:
            return nil
        }
    }
    
    var stubData: Any {
        return [:]
    }
}
