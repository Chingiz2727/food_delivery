//
//  AboutModule.swift
//  Pilican
//
//  Created by kairzhan on 3/10/21.
//

import Foundation

protocol AboutModule: Presentable {
    typealias AboutDidSelect = (About) -> Void
    var aboutDidSelect: AboutDidSelect? { get set }
    typealias CloseButton = () -> Void
    var closeButton: CloseButton? { get set }
}
