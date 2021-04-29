//
//  HowItWorkItem.swift
//  Pilican
//
//  Created by kairzhan on 4/28/21.
//

import UIKit

class HowItWorkItem: UIView {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .book12
        label.textColor = .pilicanWhite
        label.numberOfLines = 0
        return label
    }()

    private lazy var stackView = UIStackView(
        views: [imageView, titleLabel],
        axis: .horizontal,
        distribution: .fillProportionally,
        spacing: 15)

    func configureItem(image: UIImage?, title: String) {
        imageView.image = image?.withRenderingMode(.alwaysOriginal)
        titleLabel.text = title
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayouts()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupInitialLayouts() {
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
