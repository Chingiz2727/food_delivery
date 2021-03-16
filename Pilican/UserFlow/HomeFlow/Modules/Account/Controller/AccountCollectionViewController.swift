//
//  AccountCollectionViewController.swift
//  Pilican
//
//  Created by kairzhan on 3/1/21.
//

import UIKit
import RxSwift

class AccountViewController: ViewController, AccountModule, ViewHolder {
    var changePasswordDidTap: ChangePasswordDidTap?
    
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
        rootView.accountPassword.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [unowned self] in
                self.changePasswordDidTap?()
            }).disposed(by: disposeBag)
    }
}
