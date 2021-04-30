//
//  CreateOrderRatings.swift
//  Pilican
//
//  Created by kairzhan on 4/30/21.
//

import Foundation

enum CreateOrderRatings: ApiTarget {
    case createOrderRatings(comment: String, orderId: Int, type: Int, value: Int)
    var version: ApiVersion {
        .custom("")
    }
    
    var servicePath: String { "" }
    
    var path: String {
        switch self {
        case .createOrderRatings:
            return "a/cb/delivery/orders/ratings/create"
        }
    }
    
    var method: HTTPMethod {
        return .post
    }
    var parameters: [String : Any]? {
        switch self {
        case let .createOrderRatings(comment, orderId, type, value):
            return ["comment": comment, "orderId": orderId, "type": type, "value": value]
        }
    }
    
    var stubData: Any { return [:] }
}
