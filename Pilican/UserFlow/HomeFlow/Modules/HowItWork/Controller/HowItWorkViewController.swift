//
//  HowItWorkViewController.swift
//  Pilican
//
//  Created by kairzhan on 4/28/21.
//

import UIKit
class HowItWorkViewController: ViewController, ViewHolder, HowItWorkModule {
    typealias RootViewType = HowItWorkView
    
    private let workType: WorkType
    
    init(workType: WorkType) {
        self.workType = workType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func loadView() {
        view = HowItWorkView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.configureType(type: workType)
    }
}

enum WorkType {
    case bus
    case pay
}
