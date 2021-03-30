//
//  ProblemTarget.swift
//  Pilican
//
//  Created by kairzhan on 3/4/21.
//

import Foundation

enum ProblemTarget: ApiTarget {
    case sendClaims(claimIds: String, retailId: Int, description: String?)
    
    var version: ApiVersion {
        .custom("v1")
    }

    var servicePath: String { "" }

    var path: String {
        switch self {
        case .sendClaims:
            return "/claims/add"
        default:
            return ""
        }
    }

    var method: HTTPMethod {
        return .post
    }

    var parameters: [String: Any]? {
        switch self {
        case .sendClaims(let claimIds, let retailId, let description?):
            let params = [
                "claimIds": claimIds,
                "retailId": retailId,
                "description": description
            ] as [String: Any]
            return params
        default:
            return [:]
        }
    }
    
    var stubData: Any {
        return [:]
    }

    var headers: [String: String]? {
        switch self {
        case .sendClaims:
            return
                [
                    "clientId": "bW9iaWxl",
                ]
        default:
            return [:]
        }
    }
}
