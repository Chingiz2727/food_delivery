//
//  AccountCollectionViewController.swift
//  Pilican
//
//  Created by kairzhan on 3/1/21.
//

import UIKit
import RxSwift

class AccountViewController: ViewController, AccountModule, ViewHolder {
    var myCardsDidTap: MyCardsDidTap?

    typealias RootViewType = AccountView

    private let disposeBag = DisposeBag()

    override func loadView() {
        view = AccountView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
    }

    private func bindView() {
        rootView.accountCard.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [unowned self] in
                self.myCardsDidTap?()
            }).disposed(by: disposeBag)
    }
}
