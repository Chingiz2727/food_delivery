//
//  AccountCollectionViewController.swift
//  Pilican
//
//  Created by kairzhan on 3/1/21.
//

import UIKit

class AccountViewController: ViewController, AccountModule, ViewHolder {

    typealias RootViewType = AccountView

    override func loadView() {
        view = AccountView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
