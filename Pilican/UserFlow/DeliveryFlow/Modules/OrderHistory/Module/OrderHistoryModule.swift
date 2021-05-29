//
//  OrderHistoryModule.swift
//  Pilican
//
//  Created by kairzhan on 4/17/21.
//

import Foundation
protocol OrderHistoryModule: Presentable {
    typealias OnSelectOrderHistory = (DeliveryOrderResponse, Int) -> Void
    var onSelectOrderHistory: OnSelectOrderHistory? { get set }
    typealias SelectedOrderHistory = (DeliveryRetail, OrderType) -> Void
    var selectedOrderHistory: SelectedOrderHistory? { get set }
}
