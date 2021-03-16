//
//  AccountModule.swift
//  Pilican
//
//  Created by kairzhan on 3/1/21.
//

import Foundation

protocol AccountModule: Presentable {
    typealias MyQRTapped = () -> Void
    var myQRTapped: MyQRTapped? { get set }
}
