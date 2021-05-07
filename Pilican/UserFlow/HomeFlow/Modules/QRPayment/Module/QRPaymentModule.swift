//
//  QRPaymentModule.swift
//  Pilican
//
//  Created by kairzhan on 3/25/21.
//

import Foundation
protocol QRPaymentModule: Presentable {
    typealias OpenSuccesPayment = (Retail, Int, Int) -> Void
    var openSuccessPayment: OpenSuccesPayment? { get set }
    typealias CloseButton = () -> Void
    var closeButton: CloseButton? { get set }
}
