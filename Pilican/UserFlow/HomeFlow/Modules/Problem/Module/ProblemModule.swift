//
//  ProblemModule.swift
//  Pilican
//
//  Created by kairzhan on 3/4/21.
//

import Foundation

protocol ProblemModule: Presentable {
    var dissmissProblem: Callback? { get set }
}
