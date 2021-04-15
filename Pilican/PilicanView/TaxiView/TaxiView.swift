//
//  TaxiView.swift
//  Pilican
//
//  Created by kairzhan on 4/15/21.
//

import UIKit

final class TaxiView: UIView, Control {
    var control = UIControl()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.image = Images.taxi.image
        imageView.contentMode = .center
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayouts()
        isUserInteractionEnabled = true
    }

    override func layoutSubviews() {
        clipsToBounds = true
        layer.cornerRadius = 12
    }

    private func setupInitialLayouts() {
        addSubview(imageView)
        addSubview(control)
        control.snp.makeConstraints { $0.edges.equalToSuperview() }

        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        backgroundColor = .primary
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
