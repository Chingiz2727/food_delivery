//
//  RateDeliveryModule.swift
//  Pilican
//
//  Created by kairzhan on 4/7/21.
//

import Foundation
protocol RateDeliveryModule: Presentable {
    typealias RateDeliveryTapped = (DeliveryOrderResponse) -> Void
    var rateDeliveryTapped: RateDeliveryTapped? { get set }
}
