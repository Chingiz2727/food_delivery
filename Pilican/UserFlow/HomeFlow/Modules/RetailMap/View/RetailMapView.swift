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
    }
}
