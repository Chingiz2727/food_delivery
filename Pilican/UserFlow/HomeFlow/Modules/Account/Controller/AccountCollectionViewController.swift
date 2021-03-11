//
//  AccountCollectionViewController.swift
//  Pilican
//
//  Created by kairzhan on 3/1/21.
//

import UIKit

class AccountViewController: ViewController, AccountModule, ViewHolder {

    typealias RootViewType = AccountView

    private let cache = DiskCache<String, Any>()

    override func loadView() {
        view = AccountView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
