//
//  ChangePinViewController.swift
//  Pilican
//
//  Created by kairzhan on 3/15/21.
//

import UIKit
import RxSwift

class ChangePinViewController: ViewController, ViewHolder, ChangePinModule {
    var saveTapped: SaveTapped?
    
    typealias RootViewType = ChangePinView

    private let disposeBag = DisposeBag()
    private let viewModel: ChangePinViewModel

    override func loadView() {
        view = ChangePinView()
    }
    
    init(viewModel: ChangePinViewModel) {
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
        let output = viewModel.transform(
            input: .init(
                saveTapped: rootView.saveButton.rx.tap.asObservable(),
                password: rootView.passwordContainer.textField.rx.text.asObservable(),
                newPin: rootView.newPinContainer.textField.rx.text.asObservable(),
                acceptPin: rootView.acceptPinContainer.textField.rx.text.asObservable()))

        let result = output.changedPin.publish()

        result.element
            .subscribe(onNext: { [unowned self] result in
                if result.status == 200 {
                    self.saveTapped?()
                    self.showSimpleAlert(title: "", message: "Вы успешно поменяли пин код!")
                }
            }).disposed(by: disposeBag)

        result.errors
            .bind(to: rx.error)
            .disposed(by: disposeBag)

        result.connect()
            .disposed(by: disposeBag)
    }
}
