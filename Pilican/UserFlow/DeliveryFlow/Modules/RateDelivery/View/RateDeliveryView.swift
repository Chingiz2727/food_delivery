//
//  RateDeliveryView.swift
//  Pilican
//
//  Created by kairzhan on 4/7/21.
//

import UIKit
import RxSwift

class RateDeliveryView: UIView {
    let skipButton: UIButton = {
        let button = UIButton()
        button.setTitle("Пропустить", for: .normal)
        button.titleLabel?.font = .semibold16
        button.setTitleColor(.primary, for: .normal)
        return button
    }()

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.rateDelivery.image
        return imageView
    }()

    let orderInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Zhekas Doner House. Рыскулова 18.  16.09.2020"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .semibold14
        return label
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Оцените доставку"
        label.textAlignment = .center
        label.font = .semibold24
        return label
    }()

    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Ваш отзыв поможет нам улучшить качество нашего сервиса"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .book18
        return label
    }()

    let uglyView: RateView = {
        let view = RateView()
        view.imageView.image = Images.ugly.image
        return view
    }()

    let badView: RateView = {
        let view = RateView()
        view.imageView.image = Images.bad.image
        return view
    }()

    let middleView: RateView = {
        let view = RateView()
        view.imageView.image = Images.middle.image
        return view
    }()

    let goodView: RateView = {
        let view = RateView()
        view.imageView.image = Images.good.image
        return view
    }()

    let coolView: RateView = {
        let view = RateView()
        view.imageView.image = Images.cool.image
        return view
    }()

    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Далее", for: .normal)
        button.titleLabel?.font = .semibold20
        button.setTitleColor(.primary, for: .normal)
        return button
    }()

    let selectedTag = PublishSubject<Int>()
    private let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayouts()
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupData(order: DeliveryOrderResponse) {
        orderInfoLabel.text = "\(order.retailName ?? ""). \(order.address ?? ""). \(getFormatedDate(date_string: order.createdAt ?? ""))"
    }

    private func getFormatedDate(date_string: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        let dateFromInputString = dateFormatter.date(from: date_string)

        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"

        if dateFromInputString != nil {
           return dateFormatter.string(from: dateFromInputString!)
        } else {
            return "Сегодня"
        }
    }

    private func configureView() {
        uglyView.tag = 1
        badView.tag = 2
        middleView.tag = 3
        goodView.tag = 4
        coolView.tag = 5
        let controls = [uglyView, badView, middleView, goodView, coolView]
        
        controls.forEach { control in
            control.rx.controlEvent(.touchUpInside)
                .subscribe(onNext: { [unowned self] in
                    self.selectedTag.onNext(control.tag)
                }).disposed(by: disposeBag)
        }
    }

    private func setupInitialLayouts() {
        backgroundColor = .pilicanWhite
        addSubview(skipButton)
        skipButton.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.right.equalToSuperview().inset(28)
        }

        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(skipButton.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
        }

        addSubview(orderInfoLabel)
        orderInfoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }

        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(orderInfoLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }

        addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }

        addSubview(uglyView)
        uglyView.snp.makeConstraints { (make) in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(15)
            make.left.equalToSuperview().inset(23)
        }

        addSubview(badView)
        badView.snp.makeConstraints { (make) in
            make.top.equalTo(uglyView.snp.top)
            make.left.equalTo(uglyView.snp.right).offset(7)
        }

        addSubview(middleView)
        middleView.snp.makeConstraints { (make) in
            make.top.equalTo(uglyView.snp.top)
            make.left.equalTo(badView.snp.right).offset(7)
        }

        addSubview(goodView)
        goodView.snp.makeConstraints { (make) in
            make.top.equalTo(uglyView.snp.top)
            make.left.equalTo(middleView.snp.right).offset(7)
        }

        addSubview(coolView)
        coolView.snp.makeConstraints { (make) in
            make.top.equalTo(uglyView.snp.top)
            make.left.equalTo(goodView.snp.right).offset(7)
        }

        addSubview(nextButton)
        nextButton.snp.makeConstraints { (make) in
            make.top.equalTo(uglyView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
}
