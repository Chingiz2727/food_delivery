//
//  MyQRView.swift
//  Pilican
//
//  Created by kairzhan on 3/16/21.
//

import UIKit

class MyQRView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Для получения кэшбэка при оплате наличными \nпокажите свой QR код кассиру"
        label.textColor = UIColor.pilicanGray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.book14
        return label
    }()
    
    let qrImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "или назовите номер телефона"
        label.textColor = UIColor.pilicanGray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.book14
        return label
    }()

    let phoneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.semibold18
        label.textColor = .pilicanBlack
        label.textAlignment = .center
        return label
    }()
    
    let qrContainerView = UIView()

    private lazy var containerStack = UIStackView(
        views: [titleLabel, qrContainerView, subTitleLabel, phoneLabel],
        axis: .vertical,
        distribution: .equalSpacing,
        spacing: 20)

    func setData(phone: String, image: UIImage) {
        phoneLabel.text = phone
        qrImageView.image = image
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayouts()
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupInitialLayouts() {
        addSubview(containerStack)
        containerStack.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(40)
        }

        qrContainerView.snp.makeConstraints { (make) in
            make.height.equalTo(340)
        }

        qrContainerView.addSubview(qrImageView)
        qrImageView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview().inset(16)
        }
    }

    private func configureView() {
        backgroundColor = .background
        qrContainerView.backgroundColor = .pilicanWhite
        qrContainerView.layer.cornerRadius = 10
    }
}
