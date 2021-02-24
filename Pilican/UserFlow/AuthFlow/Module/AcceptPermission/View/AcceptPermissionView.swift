//
//  AcceptPermissionView.swift
//  Pilican
//
//  Created by kairzhan on 2/24/21.
//

import UIKit
import SnapKit

final class AcceptPermissionView: UIView {
    
    let termsView = TermsofPolicyView()
    
    let checkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "checkboxunselected")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let politiсyAgreementButton: UIButton = {
        let button = UIButton()
        button.setTitle("С условиями Пользовательского\nсоглашения и  Политикой конфиденциальности\nОзнакомлен(а) и Согласен(а)", for: .normal)
        button.titleLabel?.font = UIFont.medium14
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Далее", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.book16
        button.backgroundColor = .primary
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
//        button.layer.borderWidth = 1
//        button.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayouts()
    }
    
    private func setupLayouts() {
        backgroundColor = .white
        let termsContainer = UIView()
        addSubview(termsContainer)
        termsContainer.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(400)
        }
        
        termsContainer.addSubview(termsView)
        termsView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(20)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(10)
        }
        
        let bottomContainer = UIView()
        bottomContainer.backgroundColor = .white
        addSubview(bottomContainer)
        bottomContainer.snp.makeConstraints { (make) in
            make.height.equalTo(185)
            make.top.equalTo(termsContainer.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }

        let stackView = UIStackView(arrangedSubviews: [
           checkButton,
           politiсyAgreementButton
        ])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fill

        bottomContainer.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
        }

        bottomContainer.addSubview(nextButton)
        nextButton.snp.makeConstraints { (make) in
            make.top.equalTo(stackView.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview().inset(30)
            make.height.equalTo(40)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
