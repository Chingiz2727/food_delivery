//
//  OrderHistoryTarget.swift
//  Pilican
//
//  Created by kairzhan on 4/17/21.
//

import Foundation

enum OrderHistoryTarget: ApiTarget {
    case getOrderHistory(pageNumber: Int)
    var version: ApiVersion {
        .custom("")
    }
    
    var servicePath: String { "" }

    var path: String {
        switch self {
        case .getOrderHistory:
            return "a/cb/delivery/orders/completed"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }

    var parameters: [String : Any]? {
        switch self {
        case .getOrderHistory(let pageNumber):
            return ["pageNumber": pageNumber]
        }
    }
    
    var stubData: Any { return [:] }
    
    var headers: [String: String]? {
        switch self {
        case .getOrderHistory:
            return
                [
                    "clientId": "bW9iaWxl",
                ]
        }
    }
}
