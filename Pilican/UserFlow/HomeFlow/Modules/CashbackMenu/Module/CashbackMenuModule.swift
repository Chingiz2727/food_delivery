//
//  CashbackMenuModule.swift
//  Pilican
//
//  Created by kairzhan on 3/2/21.
//

import Foundation

protocol CashbackMenuModule: Presentable {
    typealias MenuDidSelect = (HomeCashbackMenu) -> Void
    
    var menuDidSelect: MenuDidSelect? { get set }
}
