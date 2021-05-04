//
//  ProductsHeaderView.swift
//  Pilican
//
//  Created by kairzhan on 5/3/21.
//

import UIKit
import RxSwift

class ProductsHeaderView: UITableViewHeaderFooterView {
    private let backView = UIView()
    private let disposeBag = DisposeBag()
    var count = 0 {
        didSet {
            buttonsLabel.countLabel.text = "\(count)"
        }
    }
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .heading2
        label.textColor = .pilicanBlack
        label.text = "Приборы"
        label.numberOfLines = 0
        return label
    }()
    private let deliveryLine = UIView()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .medium12
        label.textColor = .pilicanBlack
        label.numberOfLines = 0
        label.text = "Сколько приборов положить?"
        return label
    }()

    let buttonsLabel = DeliveryButtonsView()

    private let  priceLabel: UILabel = {
        let label = UILabel()
        label.font = .medium16
        label.textColor = .pilicanBlack
        return label
    }()
    private var swipeView = UIView()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [UIView(), nameLabel, descriptionLabel])
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 3
        return stackView
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupCount()
        setupInitialLayout()
        configureView()
    }

    required init?(coder: NSCoder) {
        nil
    }
    
    func setupCount() {
        buttonsLabel.plusButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.count += 1
            }).disposed(by: disposeBag)
        buttonsLabel.minusButton.rx.tap
            .subscribe(onNext: { [weak self] in
                if self?.count ?? 0 > 0 {
                    self?.count -= 1
                }
            }).disposed(by: disposeBag)
    }

    private func setupInitialLayout() {
        addSubview(backView)
        backView.snp.makeConstraints { $0.edges.equalToSuperview().inset(20)
        }
        
        backView.addSubview(stackView)
        backView.addSubview(deliveryLine)
        deliveryLine.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(5)
            make.height.equalTo(60)
        }

        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.equalTo(deliveryLine.snp.trailing).offset(-10)
        }
        
        backView.addSubview(buttonsLabel)
        buttonsLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(10)
        }

        deliveryLine.backgroundColor = .primary
        deliveryLine.isHidden = true
    }

    private func configureView() {
        backgroundColor = .clear
        backView.layer.cornerRadius = 10
        backView.backgroundColor = .pilicanWhite
    }
    
}
