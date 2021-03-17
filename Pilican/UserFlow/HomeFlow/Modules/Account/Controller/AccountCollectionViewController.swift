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

    private let cache = DiskCache<String, Any>()

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
        bindViewModel()
    }

    private func bindViewModel() {
        let user: User? = try? cache.readFromDisk(name: "userInfo")
        let profile: Profile? = try? cache.readFromDisk(name: "profileInfo")
        let name = profile?.firstName
        let phone = user?.username
        rootView.accountHeaderView.setData(name: name ?? "", phone: phone ?? "")
    }
}
