//
//  OrderErrorViewController.swift
//  Pilican
//
//  Created by kairzhan on 4/22/21.
//

import UIKit
import RxSwift

class OrderErrorViewController: ViewController, ViewHolder, OrderErrorModule {
    var repeatMakeOrder: RepeatMakeOrder?
    
    typealias RootViewType = OrderErrorView
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = OrderErrorView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
    }
    
    private func bindView() {
        rootView.repeatButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.repeatMakeOrder?()
            })
    }
}
