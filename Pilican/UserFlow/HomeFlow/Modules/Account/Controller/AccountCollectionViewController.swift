//
//  AccountCollectionViewController.swift
//  Pilican
//
//  Created by kairzhan on 3/1/21.
//

import UIKit
import RxSwift

class AccountViewController: ViewController, AccountModule, ViewHolder {
    var changePinTap: Callback?

    typealias RootViewType = AccountView
    
    var editAccountDidSelect: EditAccountDidSelect?
    
    private let disposeBag = DisposeBag()

    private let cache = DiskCache<String, Any>()

    override func loadView() {
        view = AccountView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
        bindViewModel()
    }

    private func bindView() {
        rootView.accountKey.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [unowned self] in
                self.changePinTap?()
            }).disposed(by: disposeBag)
    
            rootView.accountHeaderView.editAccountButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.editAccountDidSelect?()
            }).disposed(by: disposeBag)
    }

    private func bindViewModel() {
        let user: User? = try? cache.readFromDisk(name: "userInfo")
        let profile: Profile? = try? cache.readFromDisk(name: "profileInfo")
        let name = profile?.firstName
        let phone = user?.username
        rootView.accountHeaderView.setData(name: name ?? "", phone: phone ?? "")
    }
}
