//
//  PayHistoryModule.swift
//  Pilican
//
//  Created by kairzhan on 3/17/21.
//

import Foundation
protocol PayHistoryModule: Presentable {
    typealias OnSelectPayHistory = (Payments) -> Void
    var onSelectPayHistory: OnSelectPayHistory? { get set }
}
