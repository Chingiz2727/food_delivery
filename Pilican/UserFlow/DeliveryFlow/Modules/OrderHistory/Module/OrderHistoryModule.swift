//
//  OrderHistoryModule.swift
//  Pilican
//
//  Created by kairzhan on 4/17/21.
//

import Foundation
protocol OrderHistoryModule: Presentable {
    typealias OnSelectOrderHistory = (DeliveryOrderResponse) -> Void
    var onSelectOrderHistory: OnSelectOrderHistory? { get set }
}
