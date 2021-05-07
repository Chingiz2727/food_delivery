//
//  RetailMapView.swift
//  Pilican
//
//  Created by kairzhan on 4/27/21.
//

import UIKit
import YandexMapsMobile

class RetailMapView: UIView {
    let mapView = YMKMapView()
    let currentLocationButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(Images.loc.image, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupInitialLayouts() {
        addSubview(mapView)
        mapView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        addSubview(currentLocationButton)
        currentLocationButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(30)
            make.size.equalTo(30)
        }
    }
}
