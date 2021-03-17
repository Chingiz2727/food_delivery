//
//  EditAccountModule.swift
//  Pilican
//
//  Created by kairzhan on 3/11/21.
//

import Foundation

protocol EditAccountModule: Presentable {
    typealias SaveTapped = () -> Void
    
    var saveTapped: SaveTapped? { get set }
}
