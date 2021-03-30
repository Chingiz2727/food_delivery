//
//  ChangePinViewController.swift
//  Pilican
//
//  Created by kairzhan on 3/15/21.
//

import UIKit
import RxSwift

class ChangePinViewController: ViewController, ViewHolder, ChangePinModule {
    typealias RootViewType = ChangePinView

    private let disposeBag = DisposeBag()

    override func loadView() {
        view = ChangePinView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }

    private func bindViewModel() {
    }
}
