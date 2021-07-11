//
//  AccountKey.swift
//  Pilican
//
//  Created by kairzhan on 3/1/21.
//

import UIKit

class AccountKey: UIControl {

    private let cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.accountKey.image
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 13
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let cellTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Сменить пин-код"
        label.font = UIFont.medium14
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        layer.cornerRadius = 10
    }

    private func setupInitialLayout() {
        snp.makeConstraints { (make) in
            make.height.equalTo(50)
        }

        addSubview(cellImageView)
        cellImageView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().inset(12)
        }

        addSubview(cellTitleLabel)
        cellTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(cellImageView.snp.right).offset(12)
            make.top.equalToSuperview().inset(17)
        }
    }

    private func configureView() {
        backgroundColor = .pilicanWhite
    }
}
