//
//  ChangePasswordModule.swift
//  Pilican
//
//  Created by kairzhan on 3/16/21.
//

import Foundation

protocol ChangePasswordModule: Presentable {
    typealias SaveTapped = () -> Void
    var saveTapped: SaveTapped? { get set }
    typealias CloseButton = () -> Void
    var closeButton: CloseButton? { get set }
}
