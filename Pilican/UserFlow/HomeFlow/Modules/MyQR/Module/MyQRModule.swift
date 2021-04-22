//
//  MyQRModule.swift
//  Pilican
//
//  Created by kairzhan on 3/16/21.
//

import Foundation
protocol MyQRModule: Presentable {
    typealias CloseButton = () -> Void
    var closeButton: CloseButton? { get set }
}
