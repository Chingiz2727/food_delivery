//
//  ChangePasswordViewController.swift
//  Pilican
//
//  Created by kairzhan on 3/16/21.
//

import UIKit
import RxSwift

class ChangePasswordViewController: ViewController, ViewHolder, ChangePasswordModule {
    var saveTapped: SaveTapped?
    
    typealias RootViewType = ChangePasswordView

    private let disposeBag = DisposeBag()
    private let cache = DiskCache<String, Any>()
    private let viewModel: ChangePasswordViewModel

    override func loadView() {
        view = ChangePasswordView()
    }

    init(viewModel: ChangePasswordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }

    private func bindViewModel() {
        let input = ChangePasswordViewModel.Input(
            saveTapped: rootView.saveButton.rx.tap.asObservable(),
            newPassword: (rootView.newPasswordContainer.textField.rx.text.asObservable()),
            acceptPassword: rootView.acceptPasswordContainer.textField.rx.text.asObservable())
        let output = viewModel.transform(input: input)

        let user: User? = try? cache.readFromDisk(name: "userInfo")
        let login = user?.username ?? ""
        rootView.setData(login: login)

        let result = output.changedPassword.publish()

        result.element
            .subscribe(onNext: { [unowned self] _ in
                self.saveTapped?()
            }).disposed(by: disposeBag)

        result.errors
            .bind(to: rx.error)
            .disposed(by: disposeBag)

        result.connect()
            .disposed(by: disposeBag)
    }
}
