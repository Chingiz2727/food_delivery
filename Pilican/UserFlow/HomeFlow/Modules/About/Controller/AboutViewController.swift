//
//  AboutViewController.swift
//  Pilican
//
//  Created by kairzhan on 3/10/21.
//

import UIKit
import RxSwift

class AboutViewController: ViewController, ViewHolder, AboutModule {
    var closeButton: CloseButton?
    
    var aboutDidSelect: AboutDidSelect?
    
    typealias RootViewType = AboutView

    private let disposeBag = DisposeBag()
    private let appVersion = AppEnviroment.appVersion

    override func loadView() {
        view = AboutView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        title = "О нас"
    }

    private func bindViewModel() {
        rootView.setData(version: appVersion)
        rootView.phoneButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.aboutDidSelect?(.phone)
            }).disposed(by: disposeBag)
        rootView.instaButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.aboutDidSelect?(.instagram)
            }).disposed(by: disposeBag)
        rootView.youtubeButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.aboutDidSelect?(.youtube)
            }).disposed(by: disposeBag)
        rootView.webButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.aboutDidSelect?(.web)
            }).disposed(by: disposeBag)
        rootView.waButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.aboutDidSelect?(.wa)
            }).disposed(by: disposeBag)
        rootView.termButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.aboutDidSelect?(.term)
            }).disposed(by: disposeBag)
        rootView.rateButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.aboutDidSelect?(.rate)
            }).disposed(by: disposeBag)
    }
    
    override func customBackButtonDidTap() {
        closeButton?()
    }
}
