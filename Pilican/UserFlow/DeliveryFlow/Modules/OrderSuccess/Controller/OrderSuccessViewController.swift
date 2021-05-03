//
//  OrderSuccessViewController.swift
//  Pilican
//
//  Created by kairzhan on 4/22/21.
//

import UIKit
import RxSwift

class OrderSuccessViewController: ViewController, ViewHolder, OrderSuccessModule {
    var toOrderStatus: ToOrderStatus?
    var toMain: ToMain?
    
    typealias RootViewType = OrderSuccessView

    private let disposeBag = DisposeBag()
    private let orderId: Int
    private let updater: UserInfoUpdater
    
    override func loadView() {
        view = OrderSuccessView()
    }
    
    init(orderId: Int, updater: UserInfoUpdater) {
        self.orderId = orderId
        self.updater = updater
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
    }

    private func bindView() {
        rootView.toMainButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.toMain?()
            }).disposed(by: disposeBag)

        rootView.obserOrderButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.toOrderStatus?(orderId)
            }).disposed(by: disposeBag)
        updater.updateUserBalance()
    }
}
