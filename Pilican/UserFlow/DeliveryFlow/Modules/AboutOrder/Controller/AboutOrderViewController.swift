//
//  AboutOrderViewController.swift
//  Pilican
//
//  Created by kairzhan on 4/13/21.
//

import UIKit
import RxSwift

class AboutOrderViewController: ViewController, ViewHolder, AboutOrderModule {
    var aboutOrderTapped: AboutOrderTapped?
    
    typealias RootViewType = AboutOrderView
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = AboutOrderView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
    }
    
    private func bindView() {
        rootView.contactsView.retailPhoneButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.aboutOrderTapped?(.phone)
            }).disposed(by: disposeBag)
        rootView.contactsView.siteLinkButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.aboutOrderTapped?(.site)
            }).disposed(by: disposeBag)
        rootView.contactsView.supportLinkButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.aboutOrderTapped?(.support)
            }).disposed(by: disposeBag)
    }
}
