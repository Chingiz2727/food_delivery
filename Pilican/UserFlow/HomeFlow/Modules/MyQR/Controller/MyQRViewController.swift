//
//  MyQRViewController.swift
//  Pilican
//
//  Created by kairzhan on 3/16/21.
//

import UIKit
import RxSwift

class MyQRViewController: ViewController, ViewHolder, MyQRModule {
    typealias RootViewType = MyQRView
    
    private let cache = DiskCache<String, Any>()

    override func loadView() {
        view = MyQRView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
    }

    private func bindView() {
        let user: User? = try? cache.readFromDisk(name: "userInfo")
        let phone = user?.username ?? ""
        rootView.setData(phone: phone, image: generateQRCode(from: phone)!)
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
}
