//
//  SuccessPaymentModule.swift
//  Pilican
//
//  Created by kairzhan on 3/29/21.
//

import Foundation
protocol SuccessPaymentModule: Presentable {
    typealias NextTapped = () -> Void
    var nextTapped: NextTapped? { get set }
}
