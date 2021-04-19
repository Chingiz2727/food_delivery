//
//  ChangePinModule.swift
//  Pilican
//
//  Created by kairzhan on 3/15/21.
//

import Foundation

protocol ChangePinModule: Presentable {
    typealias SaveTapped = () -> Void
    var saveTapped: SaveTapped? { get set }
}
