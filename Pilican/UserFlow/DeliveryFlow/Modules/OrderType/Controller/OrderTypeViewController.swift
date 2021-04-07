//
//  OrderTypeViewController.swift
//  Pilican
//
//  Created by kairzhan on 4/7/21.
//

import UIKit
import RxSwift

class OrderTypeViewController: ViewController, ViewHolder, OrderTypeModule {
    typealias RootViewType = OrderTypeView

    private let disposeBag = DisposeBag()

    override func loadView() {
        view = OrderTypeView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
    }

    private func bindView() {
        
    }
}
