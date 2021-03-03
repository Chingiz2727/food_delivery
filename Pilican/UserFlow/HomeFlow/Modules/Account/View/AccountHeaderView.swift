//
//  AccountHeaderCell.swift
//  Pilican
//
//  Created by kairzhan on 3/1/21.
//

import UIKit

class AccountHeaderView: UIView {
    
    private let accountImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.accountImage.image
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 24
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let accountNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Иванов Иван"
        label.font = UIFont.semibold16
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    private let accountNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "+ 7 700 000 000"
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.medium16
        return label
    }()
    
    private let editAccountButton: UIButton = {
        let button = UIButton()
        button.setImage(Images.accountEdit.image, for: .normal)
        button.clipsToBounds = true
        return button
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
        super.layoutSubviews()
        layer.cornerRadius = 10
        
    }
    
    private func setupInitialLayout() {
        snp.makeConstraints { (make) in
            make.height.equalTo(75)
        }
        
        addSubview(accountImageView)
        accountImageView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().inset(14)
        }
        
        addSubview(accountNameLabel)
        accountNameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(accountImageView.snp.trailing).offset(14)
            make.top.equalToSuperview().inset(19)
        }
        
        addSubview(accountNumberLabel)
        accountNumberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(accountNameLabel.snp.left)
            make.top.equalTo(accountNameLabel.snp.bottom)
        }
        
        addSubview(editAccountButton)
        editAccountButton.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview().inset(30)
        }
    }
    
    private func configureView() {
        backgroundColor = .pilicanWhite
    }
}
