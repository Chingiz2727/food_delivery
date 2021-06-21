//
//  DeliveryRetailListHeaderView.swift
//  Pilican
//
//  Created by kairzhan on 5/5/21.
//

import UIKit
import RxSwift
import Kingfisher

final class DeliveryRetailListHeaderView: UITableViewHeaderFooterView {
    var retailSliderId: PublishSubject<DeliveryRetail?> = .init()
    private let carouselView = ImageSlideshow()
    private let disposeBag = DisposeBag()
    private var currentSliders: [Slider] = []
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .heading2
        label.text = "Рекомендации"
        return label
    }()
    
    private lazy var verticalStackView = UIStackView(
        views: [carouselView, titleLabel],
        axis: .vertical,
        spacing: 5)
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupInitialLayout()
        configureView()
        
    }
    
    func setupSlider(sliders: [Slider]) {
        currentSliders = sliders
        carouselView.setImageInputs( sliders.map { KingfisherSource(url: URL(string: $0.imgLogo )!) })
    }

    private func setupInitialLayout() {
        addSubview(verticalStackView)

        verticalStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(8)
        }

        carouselView.snp.makeConstraints { make in
            make.height.equalTo(130)
        }
        carouselView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(printSelectedIndex))
        carouselView.addGestureRecognizer(gesture)
}
    @objc private func printSelectedIndex() {
        let retail = currentSliders[carouselView.currentPage].retail
        self.retailSliderId.onNext(retail)
    }

    private func configureView() {
        
        carouselView.circular = true
        carouselView.slideshowInterval = 3
        carouselView.contentScaleMode = .scaleAspectFill
        carouselView.layer.cornerRadius = 10
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
