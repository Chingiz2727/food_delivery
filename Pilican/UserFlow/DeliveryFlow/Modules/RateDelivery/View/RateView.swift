//
//  RateView.swift
//  Pilican
//
//  Created by kairzhan on 4/7/21.
//

import UIKit

class RateView: UIControl {
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalTo(75)
            make.width.equalTo(60)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
