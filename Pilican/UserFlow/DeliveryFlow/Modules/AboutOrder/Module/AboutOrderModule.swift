//
//  AboutOrderModule.swift
//  Pilican
//
//  Created by kairzhan on 4/13/21.
//

import Foundation
protocol AboutOrderModule: Presentable {
    typealias AboutOrderTapped = (AboutOrder) -> Void
    var aboutOrderTapped: AboutOrderTapped? { get set}
}
