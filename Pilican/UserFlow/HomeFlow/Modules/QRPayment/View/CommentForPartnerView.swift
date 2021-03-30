//
//  CommentForPartnerView.swift
//  Pilican
//
//  Created by kairzhan on 3/24/21.
//

import UIKit

class CommentForPartnerView: UIView {
    
    let commentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Сообщение получателю"
        textField.backgroundColor = .pilicanWhite
        textField.font = .medium14
        textField.layer.cornerRadius = 8
        textField.setLeftPaddingPoints(16)
        return textField
    }()

    private let partnerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 18
        imageView.clipsToBounds = true
        return imageView
    }()

    private let containerView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayouts()
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(img: String) {
        partnerImageView.kf.setImage(with: URL(string: img))
    }
    private func setupInitialLayouts() {
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.left.top.bottom.right.equalToSuperview()
            make.height.equalTo(57)
        }

        containerView.addSubview(partnerImageView)
        partnerImageView.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.width.equalTo(37)
            make.height.equalTo(37)
            make.centerY.equalToSuperview()
        }

        containerView.addSubview(commentTextField)
        commentTextField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(13)
            make.right.equalTo(partnerImageView.snp.left).offset(-15)
            make.height.equalTo(47)
            make.centerY.equalToSuperview()
        }
    }

    private func configureView() {
        backgroundColor = .background
    }
}
