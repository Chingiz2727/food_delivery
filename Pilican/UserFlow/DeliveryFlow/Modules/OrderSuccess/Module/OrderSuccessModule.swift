//
//  OrderSuccessModule.swift
//  Pilican
//
//  Created by kairzhan on 4/22/21.
//

import Foundation
protocol OrderSuccessModule: Presentable {
    typealias ToMain = () -> Void
    typealias ToOrderStatus = (DeliveryOrderResponse) -> Void
    var toOrderStatus: ToOrderStatus? { get set }
    var toMain: ToMain? { get set }
}
