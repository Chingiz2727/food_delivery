//
//  OrderTypeView.swift
//  Pilican
//
//  Created by kairzhan on 4/7/21.
//

import UIKit

class OrderTypeView: UIView {
    lazy var mapView = UIView()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Как вы хотите получить заказ?"
        label.font = UIFont.semibold20
        return label
    }()

    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "2,5 км до Zhekas Doner House"
        label.font = UIFont.book12
        label.textColor = .pilicanGray
        return label
    }()

    let dividerLine = UIView()
    let secondDividerLine = UIView()

    let deliveryView = OrderTypeDeliveryView()
    let takeAwayView = OrderTypeTakeAway()
    let inPlaceView = OrderTypeInPlaceView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayouts()
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupInitialLayouts() {
        addSubview(mapView)
        mapView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(200)
        }

        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(mapView.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(21)
        }

        addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.left.equalTo(titleLabel.snp.left)
        }

        addSubview(deliveryView)
        deliveryView.snp.makeConstraints { (make) in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(78)
        }

        addSubview(dividerLine)
        dividerLine.snp.makeConstraints { (make) in
            make.top.equalTo(deliveryView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }

        addSubview(takeAwayView)
        takeAwayView.snp.makeConstraints { (make) in
            make.top.equalTo(dividerLine.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(78)
        }

        addSubview(secondDividerLine)
        secondDividerLine.snp.makeConstraints { (make) in
            make.top.equalTo(takeAwayView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }

        addSubview(inPlaceView)
        inPlaceView.snp.makeConstraints { (make) in
            make.top.equalTo(secondDividerLine.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(78)
        }
    }

    private func configureView() {
        backgroundColor = .background
        mapView.backgroundColor = .yellow
        dividerLine.backgroundColor = .pilicanLightGray
        secondDividerLine.backgroundColor = .pilicanLightGray
    }
}
