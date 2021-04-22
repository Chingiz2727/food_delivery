//
//  MyCardsFooterView.swift
//  Pilican
//
//  Created by kairzhan on 3/16/21.
//

import RxSwift
import UIKit

final class MyCardsFooterView: UIView {
    
    let addCardButton: UIButton = {
        let button = UIButton()
        button.setTitle( "Добавить карту", for: .normal)
        button.backgroundColor = .primary
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        button.layer.addShadow()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.medium16
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayouts()
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupInitialLayouts() {
        addSubview(addCardButton)
        addCardButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(50)
            make.top.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
    }

    private func configureView() {
        backgroundColor = .background
    }
}
