//
//  RateDeliveryViewController.swift
//  Pilican
//
//  Created by kairzhan on 4/7/21.
//

import UIKit
import RxSwift

class RateDeliveryViewController: ViewController, ViewHolder, RateDeliveryModule {
    var rateDeliveryTapped: RateDeliveryTapped?
    
    typealias RootViewType = RateDeliveryView

    private let disposeBag = DisposeBag()

    override func loadView() {
        view = RateDeliveryView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
    }

    private func bindView() {
        rootView.skipButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.rateDeliveryTapped?(.skip)
            }).disposed(by: disposeBag)

        rootView.nextButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.rateDeliveryTapped?(.next)
            }).disposed(by: disposeBag)
    }
}
