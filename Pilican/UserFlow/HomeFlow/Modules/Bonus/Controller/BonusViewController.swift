//
//  BonusViewController.swift
//  Pilican
//
//  Created by kairzhan on 3/10/21.
//

import UIKit
import RxSwift

class BonusViewController: ViewController, ViewHolder, BonusModule {
    var closeButton: CloseButton?
    typealias RootViewType = BonusView

    private let disposeBag = DisposeBag()
    private let cache = DiskCache<String, Any>()
    private let userInfo: UserInfoStorage
    
    init(userInfo: UserInfoStorage) {
        self.userInfo = userInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = BonusView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
    }

    private func bindView() {
        let promoCode = userInfo.promoCode
        rootView.setData(promo: promoCode ?? "", image: generateQRCode(from: promoCode ?? "")!)
        rootView.copyButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.handleCopyPromo(promoCode: promoCode ?? "")
            }).disposed(by: disposeBag)
        rootView.infoButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.handleMoreButton()
            }).disposed(by: disposeBag)
        rootView.shareButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.handleSharePromo(promo: promoCode ?? "")
            }).disposed(by: disposeBag)
    }

    private func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }

    private func handleCopyPromo(promoCode: String) {
        UIPasteboard.general.string = promoCode
        let alert = UIAlertController(title: "", message: "Скопировано", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    private func handleMoreButton() {
        // swiftlint:disable line_length
        let alert = UIAlertController(title: "", message: "Поделись с друзьями уникальной cсылкой или покажи QR код при регистрации. Если ваш друг привяжет карту любого банка к \"Pillikan\" и совершит первую покупку на сумму 500 KZT, вы и ваш друг получите по 500 бонусов", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    private func handleSharePromo(promo: String) {
        let shareText = "Привет! Скачай крутое приложение Pillikan чтоб удобно и выгодно оплачивать свои покупки, доставку еды и получать бонусы до 20% в более 1000 любимых заведении и магазинов. Введи мой промо код -\(promo) при регистрации приложении \"Pillikan\", привяжи банковскую карту и получи 500 бонусов с первой покупки. Ссылка для скачивания: https://pillikan.kz/site/get-app"

        let shareActivityController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)

        DispatchQueue.main.async {
            self.present(shareActivityController, animated: true, completion: nil)
        }
    }
    
    override func customBackButtonDidTap() {
        closeButton?()
    }
}
