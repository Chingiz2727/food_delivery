//
//  FavoritesTarget.swift
//  Pilican
//
//  Created by kairzhan on 4/16/21.
//

import Foundation

enum FavoritesTarget: ApiTarget {
    case getFavoriteRetails(type: Int)
    case changeFavoriteStatus(retail: FavoriteStatus)

    var version: ApiVersion {
        return .custom("")
    }

    var servicePath: String { "" }

    var path: String {
        switch self {
        case .getFavoriteRetails:
            return "a/cb/retail/favorites"
        case .changeFavoriteStatus:
            return "a/cb/retail/favorites/status"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getFavoriteRetails:
            return .get
        case .changeFavoriteStatus:
            return .post
        }
    }

    var parameters: [String : Any]? {
        switch self {
        case .changeFavoriteStatus(let retail):
            return ["id": retail.id, "status": retail.status]
        case .getFavoriteRetails(let type):
            return ["type": type]
        }
    }

    var stubData: Any { return [:] }
}
