//
//  HowItWorkView.swift
//  Pilican
//
//  Created by kairzhan on 4/28/21.
//

import UIKit

class HowItWorkView: UIView {
    let dataView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Как это работает?"
        label.textColor = .pilicanWhite
        label.font = .semibold24
        return label
    }()
    
    private let firstItem = HowItWorkItem()
    private let secondItem = HowItWorkItem()
    private let thirdItem = HowItWorkItem()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayouts()
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupInitialLayouts() {
        addSubview(dataView)
        dataView.snp.makeConstraints { (make) in
            make.width.equalTo(330)
            make.height.equalTo(400)
            make.centerX.centerY.equalToSuperview()
        }
        
        dataView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(27)
            make.centerX.equalToSuperview()
        }

        dataView.addSubview(firstItem)
        firstItem.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
            make.left.right.equalToSuperview().inset(30)
        }

        dataView.addSubview(secondItem)
        secondItem.snp.makeConstraints { (make) in
            make.top.equalTo(firstItem.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(30)
        }

        dataView.addSubview(thirdItem)
        thirdItem.snp.makeConstraints { (make) in
            make.top.equalTo(secondItem.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(30)
        }
    }

    func configureType(type: WorkType) {
        switch type {
        case .pay:
            firstItem.configureItem(image: Images.firstItem.image, title: "- Сканируй QR код 'Pillikan' в любимых заведениях")
            secondItem.configureItem(image: Images.secondItem.image, title: "- Привяжи карту любого банка и оплачивай покупки с кэшбэком да 20%")
            thirdItem.configureItem(image: Images.thirdItem.image, title: "- Трать накопленные бонусы у любого партнера 'Pillikan'")
        case .bus:
            firstItem.configureItem(image: Images.firstItem.image, title: "- сканируй QR код Pillikan в автобусе")
            secondItem.configureItem(image: Images.secondItem.image, title: "- Выбери свой проездной тариф ")
            thirdItem.configureItem(image: Images.thirdItem.image, title: "- Оплати проезд и покажи чек контроллеру")
        case .promo:
            firstItem.configureItem(image: Images.firstItem.image, title: "- Сканируй QR код друга")
            secondItem.configureItem(image: Images.secondItem.image, title: "Привяжи карту любого банка и соверши покупку на сумму 500  ₸ ")
            thirdItem.configureItem(image: Images.thirdItem.image, title: "- Получите по 500 бонусов каждый")
        }
    }
    private func configureView() {
        dataView.backgroundColor = .howItWork
        dataView.layer.cornerRadius = 10
        backgroundColor = .clear
        firstItem.configureItem(image: Images.firstItem.image, title: "- Сканируй QR код 'Pillikan' в любимых заведениях")
        secondItem.configureItem(image: Images.secondItem.image, title: "- Привяжи карту любого банка и оплачивай покупки с кэшбэком да 20%")
        thirdItem.configureItem(image: Images.thirdItem.image, title: "- Трать накопленные бонусы у любого партнера 'Pillikan'")
    }
}
