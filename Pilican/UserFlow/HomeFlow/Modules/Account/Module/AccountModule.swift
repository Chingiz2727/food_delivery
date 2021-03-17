//
//  AccountModule.swift
//  Pilican
//
//  Created by kairzhan on 3/1/21.
//

import Foundation

protocol AccountModule: Presentable {
    typealias EditAccountDidSelect = () -> Void

    var changePinTap: Callback? { get set }
    var editAccountDidSelect: EditAccountDidSelect? { get set }
}
