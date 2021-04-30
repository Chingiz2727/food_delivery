//
//  RateMealViewController.swift
//  Pilican
//
//  Created by kairzhan on 4/7/21.
//

import UIKit
import RxSwift

class RateMealViewController: ViewController, ViewHolder, RateMealModule {
    var rateMealTapped: RateMealTapped?
    
    typealias RootViewType = RateMealView

    private let disposeBag = DisposeBag()
    private let order: DeliveryOrderResponse
    private let viewModel: RateMealViewModel

    override func loadView() {
        view = RateMealView()
    }
    
    init(order: DeliveryOrderResponse, viewModel: RateMealViewModel) {
        self.order = order
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
    }

    private func bindView() {
        let output = viewModel.transform(input: .init(
                                            ratingSelected: rootView.selectedTag,
                ratingValue: rootView.selectedTag))

        let result = output.result.publish()

        result.element
            .subscribe(onNext: { [unowned self] _ in
                showRateAlert {
                    self.rateMealTapped?()
                }
            }).disposed(by: disposeBag)

        result.errors
            .bind(to: rx.error)
            .disposed(by: disposeBag)
        
        result.connect()
            .disposed(by: disposeBag)
        rootView.skipButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.rateMealTapped?()
            }).disposed(by: disposeBag)

        rootView.nextButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.rateMealTapped?()
            }).disposed(by: disposeBag)

        rootView.setupData(order: order)
    }
}
