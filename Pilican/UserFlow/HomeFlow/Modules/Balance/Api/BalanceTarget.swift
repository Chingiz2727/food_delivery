//
//  BalanceTarget.swift
//  Pilican
//
//  Created by kairzhan on 4/20/21.
//

import Foundation

enum BalanceTarget: ApiTarget {
    case replenishBalance(sig: String, amount: Float, createdAt: String)
    
    var version: ApiVersion {
        .custom("")
    }
    
    var servicePath: String {
        ""
    }
    
    var path: String {
        switch self {
        case .replenishBalance:
            return "a/cb/purchase/replenish"
        }
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var parameters: [String : Any]? {
        switch self {
        case let .replenishBalance(sig, amount, createdAt):
            return ["sig": sig, "amount": amount, "createdAt": createdAt]
        }
    }
    
    var stubData: Any {
        return [:]
    }
}
