//
//  AlcoholViewController.swift
//  Pilican
//
//  Created by kairzhan on 4/22/21.
//

import UIKit
import RxSwift

class AlcoholViewController: ViewController, ViewHolder, AlcoholModule {
    typealias RootViewType = AlcoholView

    var acceptButtonTapped: AcceptButtonTapped?
    private let disposeBag = DisposeBag()

    override func loadView() {
        view = AlcoholView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
    }

    private func bindView() {
        rootView.acceptButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.acceptButtonTapped?()
            }).disposed(by: disposeBag)
    }
}
