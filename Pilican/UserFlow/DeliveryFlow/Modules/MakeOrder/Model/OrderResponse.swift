//
//  MakeOrderResponse.swift
//  Pilican
//
//  Created by kairzhan on 4/21/21.
//

import Foundation
struct OrderResponse: Codable {
    let order: Order?
    let newBalance: Int?
    let status: Int?
}

struct Order: Codable {
    var id: Int? = 0
    var address: String? = ""
    var contactless: Int? = 00000
    var cookingDeadline: String?
    var createdAt: String?
    var updatedAt: String? = ""
    var status: Int?
    var deliveryAmount: Int? = 00000
    var foodAmount: Int? = 00000
    var fullAmount: Int? = 00000
    var latitude: Double? = 1.1
    var longitude: Double? = 1.1
    var orderItemsReq: [Product]?
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
