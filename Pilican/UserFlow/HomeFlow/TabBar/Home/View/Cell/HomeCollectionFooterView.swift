//
//  HomeCollectionFooterView.swift
//  Pilican
//
//  Created by kairzhan on 5/7/21.
//

import UIKit

class HomeCollectionFooterView: UICollectionReusableView {
    let button = PrimaryButton()
    var tapAction: Callback?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayouts()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupInitialLayouts()
        configureView()
        button.isUserInteractionEnabled = true
    }
    
    private func setupInitialLayouts() {
        addSubview(button)
        button.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(10)
            make.left.right.equalToSuperview().inset(40)
            make.height.equalTo(40)
        }
        button.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
    }
    
    @objc private func buttonTap() {
        tapAction?()
    }
    private func configureView() {
        button.setTitle("Посмотреть полный список", for: .normal)
    }
}
