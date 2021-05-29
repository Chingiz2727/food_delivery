//
//  OrderTypeModule.swift
//  Pilican
//
//  Created by kairzhan on 4/7/21.
//

import Foundation
import CoreLocation
protocol OrderTypeModule: Presentable {
    typealias OnDeliveryChoose = (OrderType, CLLocationCoordinate2D) -> Void
    var onDeliveryChoose: OnDeliveryChoose? { get set }
}
