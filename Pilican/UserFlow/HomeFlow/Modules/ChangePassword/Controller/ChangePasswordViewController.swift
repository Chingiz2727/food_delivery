//
//  ChangePasswordViewController.swift
//  Pilican
//
//  Created by kairzhan on 3/16/21.
//

import UIKit
import RxSwift

class ChangePasswordViewController: ViewController, ViewHolder, ChangePasswordModule {
    var closeButton: CloseButton?
    
    var saveTapped: SaveTapped?

    typealias RootViewType = ChangePasswordView

    private let disposeBag = DisposeBag()
    private let viewModel: ChangePasswordViewModel
    private let userInfoStorage: UserInfoStorage

    override func loadView() {
        view = ChangePasswordView()
    }

    init(viewModel: ChangePasswordViewModel, userInfoStorage: UserInfoStorage) {
        self.viewModel = viewModel
        self.userInfoStorage = userInfoStorage
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

        guard let login = userInfoStorage.mobilePhoneNumber else { return }
        rootView.setData(login: login)

        let result = output.changedPassword.publish()

        result.element
            .subscribe(onNext: { [unowned self] res in
                if res.status == 200 {
                    self.showAlert()
                }
            }).disposed(by: disposeBag)

        result.errors
            .bind(to: rx.error)
            .disposed(by: disposeBag)

        result.connect()
            .disposed(by: disposeBag)
    }

    private func showAlert() {
        self.showSuccessAlert { [unowned self] in
            self.saveTapped?()
        }
    }

    override func customBackButtonDidTap() {
        closeButton?()
    }
}
