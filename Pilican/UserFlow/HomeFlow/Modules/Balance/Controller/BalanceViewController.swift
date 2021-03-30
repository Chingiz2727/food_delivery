//
//  BalanceViewController.swift
//  Pilican
//
//  Created by kairzhan on 3/17/21.
//

import UIKit

class BalanceViewController: ViewController, ViewHolder, BalanceModule {
    typealias RootViewType = BalanceView

    override func loadView() {
        view = BalanceView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
    }
    
    private func bindView() {
        
    }
}
