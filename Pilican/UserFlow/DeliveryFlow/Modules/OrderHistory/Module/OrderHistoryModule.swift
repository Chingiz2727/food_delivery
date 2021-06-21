//
//  OrderHistoryModule.swift
//  Pilican
//
//  Created by kairzhan on 4/17/21.
//

import Foundation
import CoreLocation
protocol OrderHistoryModule: Presentable {
    typealias OnSelectOrderHistory = (DeliveryOrderResponse, Int) -> Void
    typealias RemakeOrder = (OrderType, CLLocationCoordinate2D) -> Void
    
    var onSelectOrderHistory: OnSelectOrderHistory? { get set }
    typealias SelectedOrderHistory = (DeliveryRetail, OrderType) -> Void
    var selectedOrderHistory: SelectedOrderHistory? { get set }
    var remakeOrder: RemakeOrder? { get set }
}
