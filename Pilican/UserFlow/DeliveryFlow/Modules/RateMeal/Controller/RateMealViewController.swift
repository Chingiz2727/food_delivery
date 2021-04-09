//
//  RateMealViewController.swift
//  Pilican
//
//  Created by kairzhan on 4/7/21.
//

import UIKit
import RxSwift

class RateMealViewController: ViewController, ViewHolder, RateMealModule {
    var rateMealTapped: RateMealTapped?
    
    typealias RootViewType = RateMealView

    private let disposeBag = DisposeBag()

    override func loadView() {
        view = RateMealView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
    }

    private func bindView() {
        rootView.skipButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.rateMealTapped?(.skip)
            }).disposed(by: disposeBag)

        rootView.nextButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.rateMealTapped?(.next)
            }).disposed(by: disposeBag)
    }
}
