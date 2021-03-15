//
//  AccountCollectionViewController.swift
//  Pilican
//
//  Created by kairzhan on 3/1/21.
//

import UIKit
import RxSwift

class AccountViewController: ViewController, AccountModule, ViewHolder {
    var editAccountDidSelect: EditAccountDidSelect?
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
        rootView.accountHeaderView.editAccountButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.editAccountDidSelect?()
            }).disposed(by: disposeBag)
    }
}
