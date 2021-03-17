//
//  ProblemViewController.swift
//  Pilican
//
//  Created by kairzhan on 3/4/21.
//

import UIKit
import RxSwift

class ProblemViewController: ViewController, ViewHolder, ProblemModule {
    var dissmissProblem: Callback?

    typealias RootViewType = ProblemView

    private let disposeBag = DisposeBag()
    private let viewModel: ProblemViewModel

    init(viewModel: ProblemViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = ProblemView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }

    private func bindViewModel() {
        let input = ProblemViewModel.Input(
            sendTapped: rootView.sendButton.rx.tap.asObservable(),
            claimIds: rootView.claimids,
            description: rootView.textField.rx.text.asObservable())

        let output = viewModel.transform(input: input)

        let result = output.claims.publish()

        result.element
            .subscribe(onNext: { [unowned self] _ in
                self.dissmissProblem?()
            })
            .disposed(by: disposeBag)

        result.errors
            .bind(to: rx.error)
            .disposed(by: disposeBag)

        result.connect()
            .disposed(by: disposeBag)
    }
}
