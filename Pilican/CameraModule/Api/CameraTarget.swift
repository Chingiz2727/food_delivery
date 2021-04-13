//
//  CameraTarget.swift
//  Pilican
//
//  Created by kairzhan on 3/24/21.
//

import Foundation

enum CameraTarget: ApiTarget {
    case retailScan(retailId: Int, createdAt: String, sig: String)
    
    var version: ApiVersion {
        .custom("")
    }
    
    var servicePath: String { "" }
    
    var path: String {
        switch self {
        case .retailScan:
            return "a/cb/purchase/request/retail/by/muser"
        }
    }

    var method: HTTPMethod {
        return .post
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .retailScan(let retailId, let createdAt, let sig):
            let params = [
                "retailId": retailId,
                "createdAt": createdAt,
                "sig": sig
            ] as [String : Any]
            return params
        }
    }

    var stubData: Any {
        return [:]
    }
    
    var headers: [String : String]? {
        switch self {
        case .retailScan:
            return [
                "clientId": "bW9iaWxl",
                "appver": "3.2.1"
            ]
        }
    }
}
