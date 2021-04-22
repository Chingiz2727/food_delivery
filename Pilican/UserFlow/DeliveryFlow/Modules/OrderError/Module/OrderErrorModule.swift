//
//  OrderErrorModule.swift
//  Pilican
//
//  Created by kairzhan on 4/22/21.
//

import Foundation
protocol OrderErrorModule: Presentable {
    typealias RepeatMakeOrder = () -> Void
    var repeatMakeOrder: RepeatMakeOrder? { get set }
}
