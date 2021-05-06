//
//  RetailMapViewController.swift
//  Pilican
//
//  Created by kairzhan on 4/27/21.
//
import RxSwift
import UIKit
import CoreLocation

class RetailMapViewController: ViewController, ViewHolder, RetailMapModule {
    typealias RootViewType = RetailMapView
    
    private let mapManager: MapManager<YandexMapViewModel>
    private let retail: Retail
    private let disposeBag = DisposeBag()
    private let secondManager = CLLocationManager()
    
    override func loadView() {
        view = RetailMapView()
    }
    
    init(mapManager: MapManager<YandexMapViewModel>, retail: Retail) {
        self.mapManager = mapManager
        self.retail = retail
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
        configureMap()
    }

    private func bindView() {
        rootView.currentLocationButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.moveToMyLocation()
            }).disposed(by: disposeBag)
    }
    
    private func moveToMyLocation() {
        if let coordinate = secondManager.location?.coordinate {
            let viewModel = MapTransitionViewModel(duration: 0.1, animationType: .smooth, zoom: 13)
            mapManager.moveTo(in: rootView.mapView, point: MapPoint(latitude: coordinate.latitude, longitude: coordinate.longitude), transitionViewModel: viewModel)
        }
    }
    
    private func configureMap() {
        let transitionViewModel = MapTransitionViewModel(duration: 0.1, animationType: .smooth, zoom: 12)
        mapManager.moveTo(in: rootView.mapView, point: MapPoint(latitude: 42.340782, longitude: 69.596329), transitionViewModel: transitionViewModel)
        // swiftlint:disable line_length
        mapManager.createAnnotation(in: rootView.mapView, at: MapPoint(latitude: retail.latitude ?? 0.0, longitude: retail.longitude ?? 0.0), image: Images.mapIcon.image, associatedData: nil)
        mapManager.showCurrentLocation(in: rootView.mapView)
    }
}
