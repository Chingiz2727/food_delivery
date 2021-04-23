//
//  MyCardsModule.swift
//  Pilican
//
//  Created by kairzhan on 3/16/21.
//

import Foundation

protocol MyCardsModule: Presentable {
    typealias CloseButton = () -> Void
    typealias AddCard = (String) -> Void
    var addCard: AddCard? { get set }
    var closeButton: CloseButton? { get set }
    
}
