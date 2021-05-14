//
//  MyQRViewController.swift
//  Pilican
//
//  Created by kairzhan on 3/16/21.
//

import UIKit
import RxSwift

class MyQRViewController: ViewController, ViewHolder, MyQRModule {
    var closeButton: CloseButton?
    
    typealias RootViewType = MyQRView

    private let cache = DiskCache<String, Any>()
    private let userInfo: UserInfoStorage

    override func loadView() {
        view = MyQRView()
    }
    
    init(userInfo: UserInfoStorage) {
        self.userInfo = userInfo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
        title = "Мой QR"
    }

    private func bindView() {
        let phone = userInfo.mobilePhoneNumber
        rootView.setData(phone: phone ?? "", image: generateQRCode(from: phone ?? ""))
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

    override func customBackButtonDidTap() {
        closeButton?()
    }
}
