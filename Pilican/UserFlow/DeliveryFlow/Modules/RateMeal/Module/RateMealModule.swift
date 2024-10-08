//
//  RateMealModule.swift
//  Pilican
//
//  Created by kairzhan on 4/7/21.
//

import Foundation
protocol RateMealModule: Presentable {
    typealias RateMealTapped = () -> Void
    var rateMealTapped: RateMealTapped? { get set }
}
