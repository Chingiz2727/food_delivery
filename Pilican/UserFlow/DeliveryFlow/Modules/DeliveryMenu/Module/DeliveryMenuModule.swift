//
//  DeliveryMenuModule.swift
//  Pilican
//
//  Created by kairzhan on 4/16/21.
//

import Foundation

protocol DeliveryMenuModule: Presentable {
    typealias DeliveryMenuDidSelect = (DeliveryMenu) -> Void
    
    var deliveryMenuDidSelect: DeliveryMenuDidSelect? { get set }
}
