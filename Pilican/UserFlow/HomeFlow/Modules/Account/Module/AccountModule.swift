//
//  AccountModule.swift
//  Pilican
//
//  Created by kairzhan on 3/1/21.
//

import Foundation

protocol AccountModule: Presentable {
    typealias ProfileItemsDidSelect = (ProfileItems) -> Void
    var profileItemsDidSelect: ProfileItemsDidSelect? { get set }
    typealias CloseButton = () -> Void
    var closeButton: CloseButton? { get set }
}
