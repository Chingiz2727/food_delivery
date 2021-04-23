//
//  BonusModule.swift
//  Pilican
//
//  Created by kairzhan on 3/10/21.
//

import Foundation

protocol BonusModule: Presentable {
    typealias CloseButton = () -> Void
    var closeButton: CloseButton? { get set }
}
