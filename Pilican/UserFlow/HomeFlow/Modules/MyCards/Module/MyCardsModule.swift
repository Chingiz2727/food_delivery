//
//  MyCardsModule.swift
//  Pilican
//
//  Created by kairzhan on 3/16/21.
//

import Foundation

protocol MyCardsModule: Presentable {
    var addCard: Callback? { get set }
}
