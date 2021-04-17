//
//  FavoritesModule.swift
//  Pilican
//
//  Created by kairzhan on 4/16/21.
//

import Foundation
protocol FavoritesModule: Presentable {
    typealias OnRetailDidSelect = (DeliveryRetail) -> Void

    var onRetailDidSelect: OnRetailDidSelect? { get set }
}
