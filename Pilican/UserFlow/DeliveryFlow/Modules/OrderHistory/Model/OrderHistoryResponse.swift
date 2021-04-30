//
//  OrderHistoryResponse.swift
//  Pilican
//
//  Created by kairzhan on 4/17/21.
//

import RxDataSources

struct OrderHistoryResponse: Codable, Pagination {

    let orders: ConfirmedOrder?
    var totalElements: Int? {
        return orders?.content.count
    }
    var items: [DeliveryOrderResponse] {
        return orders?.content ?? []
    }
    var hasNext: Bool? {
        return orders?.hasNext
    }
}

struct ConfirmedOrder: Codable {
    var hasNext: Bool?
    var content: [DeliveryOrderResponse]
    var hasPrevious: Bool?
}

public struct DeliveryOrderResponse: Codable, RetailAdapter {
    var retailImgUrl: String? {
        retailLogo
    }
    
    var retailRating: Double? {
        0
    }
    
    var retailStatus: Int? {
        status
    }
    
    var retailAdress: String? {
        address
    }
    
    var id: Int? = 0
    var address: String? = ""
    var contactless: Int? = 00000
    var cookingDeadline: String?
    var createdAt: String
    var updatedAt: String? = ""
    var status: Int?
    var deliveryAmount: Int? = 00000
    var foodAmount: Int? = 00000
    var fullAmount: Int? = 00000
    var latitude: Double? = 1.1
    var longitude: Double? = 1.1
    var orderItemsReq: [Dishes]?
    var orderItems: [OrderItems]?
    var retailId: Int? = 00000
    var type: Int? = 00000
    var utensils: Int? = 00000
    var addAmount: Int? = 00000
    var cardId: Int? = 00000
    var description: String? = ""
    var useCashback: Bool? = false
    var retailLogo: String? = ""
    var retailName: String? = ""
    var isExpanded: Bool? = false
}

struct OrderItems: Codable {
    var id: Int?
    var amount: Int?
    var quantity: Int?
    var dish: Dishes?
}

class Dishes: Codable {
    var composition: String?
    var id: Int
    var img: String?
    var name: String?
    var price: Int?
    let status: Int?
    
    var inShoppingList: Bool? = false
    var shoppingCount: Int? = 0
    var itemTotalSum: Int? = 0
    var allItemTotalSum: Int? = 0
    var addAmount: Int? = 0
    var age_access: Int?
}
