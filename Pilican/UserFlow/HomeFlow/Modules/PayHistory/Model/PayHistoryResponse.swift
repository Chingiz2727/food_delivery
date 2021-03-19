//
//  PayHistoryResponse.swift
//  Pilican
//
//  Created by kairzhan on 3/17/21.
//

import RxDataSources

struct PaymentHistoryResponse: Codable, Pagination {
    var totalElements: Int {
        return totalCount
    }
    
    var payments: [Payments]
    var totalCount: Int
    var status: Int
    var items: [Payments] {
        return payments
    }
}

struct Payments: Codable {
    var id: Int
    var amount: Float
    var cbAmount: Float
    var updatedAt: String
    var retail: RetailName?
}

struct RetailName: Codable {
    var name: String
}
