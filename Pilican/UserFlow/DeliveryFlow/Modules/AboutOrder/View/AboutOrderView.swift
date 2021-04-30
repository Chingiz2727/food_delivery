//
//  AboutOrderView.swift
//  Pilican
//
//  Created by kairzhan on 4/13/21.
//

import UIKit

class AboutOrderView: UIView {
    let scrollView = UIScrollView()
    let retailNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Zheka's Doner House"
        label.font = .semibold24
        return label
    }()

    let addressTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Адрес"
        label.font = .semibold20
        return label
    }()

    let retailAddressLabel: UILabel = {
        let label = UILabel()
        label.text = "ул.Рыскулова, 24"
        label.font = .book16
        label.textColor = .pilicanGray
        return label
    }()

    let routeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Маршрут"
        label.textAlignment = .right
        label.font = .semibold16
        label.textColor = .primary
        return label
    }()

    let workTimeView = WorkTimeView()

    let dividerLine = UIView()
    let secondDividerLine = UIView()

    let aboutDeliveryView = AboutDeliveryView()

    let contactsView = AboutContactsView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayouts()
        configureView()
        scrollView.alwaysBounceVertical = true
        scrollView.bounces = false
    }

    func setupData(retail: Retail, workCalender: WorkCalendar) {
        retailNameLabel.text = retail.name
        retailAddressLabel.text = retail.address
        workTimeView.setupData(workDay: retail.workDays ?? [], workCalendar: workCalender)
        aboutDeliveryView.setupData()
        contactsView.setupData(retail: retail)
    }

    private func setupInitialLayouts() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints { $0.edges.width.height.equalTo(safeAreaLayoutGuide)
        }

        scrollView.addSubview(retailNameLabel)
        retailNameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(27)
            make.left.right.equalTo(self).inset(18)
        }

        scrollView.addSubview(addressTitleLabel)
        addressTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(retailNameLabel.snp.bottom).offset(60)
            make.left.equalTo(self).inset(18)
        }

        addSubview(routeTitleLabel)
        routeTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(addressTitleLabel.snp.bottom).offset(7)
            make.right.equalTo(self).inset(18)
        }

        addSubview(retailAddressLabel)
        retailAddressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(addressTitleLabel.snp.bottom).offset(7)
            make.left.equalTo(self).inset(18)
        }

        addSubview(workTimeView)
        workTimeView.snp.makeConstraints { (make) in
            make.top.equalTo(routeTitleLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(18)
        }

        addSubview(dividerLine)
        dividerLine.snp.makeConstraints { (make) in
            make.top.equalTo(workTimeView.snp.bottom).offset(15)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }

        scrollView.addSubview(aboutDeliveryView)
        aboutDeliveryView.snp.makeConstraints { (make) in
            make.top.equalTo(dividerLine.snp.bottom).offset(10)
            make.left.right.equalTo(self).inset(18)
        }

        addSubview(secondDividerLine)
        secondDividerLine.snp.makeConstraints { (make) in
            make.top.equalTo(aboutDeliveryView.snp.bottom).offset(15)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }

        scrollView.addSubview(contactsView)
        contactsView.snp.makeConstraints { (make) in
            make.top.equalTo(secondDividerLine.snp.bottom).offset(10)
            make.left.right.equalTo(self).inset(18)
            make.bottom.equalToSuperview().inset(30)
        }
    }

    private func configureView() {
        backgroundColor = .background
        dividerLine.backgroundColor = .pilicanLightGray
        secondDividerLine.backgroundColor = .pilicanLightGray
        workTimeView.layer.cornerRadius = 10
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
