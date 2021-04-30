//
//  HowItWorkViewController.swift
//  Pilican
//
//  Created by kairzhan on 4/28/21.
//

import UIKit
class HowItWorkViewController: ViewController, ViewHolder, HowItWorkModule {
    typealias RootViewType = HowItWorkView
    
    override func loadView() {
        view = HowItWorkView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
