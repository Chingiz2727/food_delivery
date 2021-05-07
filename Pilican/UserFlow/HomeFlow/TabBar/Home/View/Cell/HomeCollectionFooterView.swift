//
//  HomeCollectionFooterView.swift
//  Pilican
//
//  Created by kairzhan on 5/7/21.
//

import UIKit

class HomeCollectionFooterView: UICollectionReusableView {
    let button = PrimaryButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayouts()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupInitialLayouts() {
        addSubview(button)
        button.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(40)
            make.height.equalTo(40)
        }
    }
    
    private func configureView() {
        button.setTitle("Посмотреть полный список", for: .normal)
    }
}
