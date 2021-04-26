//
//  AlcoholModule.swift
//  Pilican
//
//  Created by kairzhan on 4/22/21.
//

import Foundation
protocol AlcoholModule: Presentable {
    typealias AcceptButtonTapped = () -> Void
    var acceptButtonTapped: AcceptButtonTapped? { get set }
}
