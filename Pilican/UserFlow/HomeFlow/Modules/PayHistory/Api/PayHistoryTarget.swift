//
//  PayHistoryTarget.swift
//  Pilican
//
//  Created by kairzhan on 3/17/21.
//

import Foundation

enum PayHistoryTarget: ApiTarget {
    case getPayHistory(pageNumber: Int)
    
    var version: ApiVersion {
        .custom("")
    }
    
    var servicePath: String { "" }
    
    var path: String {
        switch self {
        case .getPayHistory:
            return "payment/history/user"
        default:
            break
        }
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getPayHistory(let pageNumber):
            return ["pageNumber": pageNumber]
        default:
            return [:]
        }
    }

    var stubData: Any {
        return [:]
    }

    var headers: [String: String]? {
        switch self {
        case .getPayHistory:
            return
                [
                    "clientId": "bW9iaWxl",
                    "appver": "3.0.0"
                ]
        default:
            return [:]
        }
    }
}
