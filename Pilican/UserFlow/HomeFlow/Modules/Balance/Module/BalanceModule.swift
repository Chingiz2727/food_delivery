//
//  BalanceModule.swift
//  Pilican
//
//  Created by kairzhan on 3/17/21.
//

import Foundation
protocol BalanceModule: Presentable {
    typealias DissmissBalanceModule = () -> Void
    var dissmissBalanceModule: DissmissBalanceModule? { get set }
    typealias CloseButton = () -> Void
    var closeButton: CloseButton? { get set }
}
