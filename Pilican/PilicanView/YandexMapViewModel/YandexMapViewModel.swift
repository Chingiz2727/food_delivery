import CoreLocation
import YandexMapsMobile

final class YandexMapViewModel: NSObject, MapStatus {
    func getAddressName(long: Double, lat: Double) -> String {
        return ""
    }
    
    func getDistance(userPoint: MapPoint, retailPoint: MapPoint) -> Float {
        return 0.0
    }
    
    typealias MapView = YMKMapView
    var userLocationViewModel: MapUserLocationViewModel?
    
    var onAnnotationDidTap: ((Any?) -> Void)?
    var onCameraPositionChanged: ((MapPoint?) -> Void)?
    
    func showCurrentLocation(in view: YMKMapView) {
        let mapKit = YMKMapKit.sharedInstance()
        let userLocationLayer = mapKit.createUserLocationLayer(with: view.mapWindow)
        userLocationLayer.setVisibleWithOn(true)
        userLocationLayer.isHeadingEnabled = true
        userLocationLayer.setObjectListenerWith(self)
    }
    
    func moveTo(in view: YMKMapView, point: MapPoint, transitionViewModel: MapTransitionViewModel, completionHandler: Callback?) {
        let animationType = mapAnimationTypeToYMKAnimationType(transitionViewModel.animationType)
        moveTo(in: view,
               point: point,
               zoom: transitionViewModel.zoom,
               animationType: animationType,
               animationDuration: transitionViewModel.duration,
               completionHandler: completionHandler)
    }
    
    func setRegion(in view: YMKMapView, minPoint: MapPoint, maxPoint: MapPoint, transitionViewModel: MapTransitionViewModel, completionHandler: Callback?) {
        let animationType = mapAnimationTypeToYMKAnimationType(transitionViewModel.animationType)
        moveToWithBoundingBox(in: view,
                              minPoint: minPoint,
                              maxPoint: maxPoint,
                              animationType: animationType,
                              animationDuration: transitionViewModel.duration,
                              completionHandler: completionHandler)
    }
    
    func getDistance(firstPoint: MapPoint, secondPoint: MapPoint) -> Double {
        return YMKDistance(
            YMKPoint(latitude: firstPoint.latitude, longitude: firstPoint.longitude),
            YMKPoint(latitude: secondPoint.latitude, longitude: secondPoint.longitude)).rounded()
    }
    
    func createAnnotation(in view: YMKMapView, at point: MapPoint, image: UIImage?, associatedData: Any?) {
        let map = view.mapWindow.map
        let placeMark = map.mapObjects.addPlacemark(with: .init(latitude: point.latitude, longitude: point.longitude))
        placeMark.userData = associatedData
        if let image = image { placeMark.setIconWith(image) }
        placeMark.addTapListener(with: self)
    }
    
    private func moveTo(in view: MapView,
                        point: MapPoint,
                        zoom: Float,
                        animationType: YMKAnimationType,
                        animationDuration: Float,
                        completionHandler: Callback?) {
        let map = view.mapWindow.map
        map.move(with: .init(target: .init(latitude: point.latitude, longitude: point.longitude),
                                  zoom: zoom,
                                  azimuth: 0,
                                  tilt: 0),
                 animationType: .init(type: animationType, duration: animationDuration),
                 cameraCallback: .some({ _ in completionHandler?() }))
    }
    
    
    private func moveToWithBoundingBox(in view: MapView,
                                       minPoint: MapPoint,
                                       maxPoint: MapPoint,
                                       animationType: YMKAnimationType,
                                       animationDuration: Float,
                                       completionHandler: Callback?) {
        let map = view.mapWindow.map
        let box = YMKBoundingBox(southWest: .init(latitude: minPoint.latitude, longitude: minPoint.longitude),
                                 northEast: .init(latitude: maxPoint.latitude, longitude: maxPoint.longitude))
        var cameraPosition = map.cameraPosition(with: box)
        cameraPosition = YMKCameraPosition(target: cameraPosition.target,
                                           zoom: cameraPosition.zoom,
                                           azimuth: cameraPosition.azimuth,
                                           tilt: cameraPosition.tilt)
        map.move(with: cameraPosition,
                 animationType: .init(type: animationType, duration: animationDuration),
                 cameraCallback: .some({ _ in completionHandler?() }))
    }
    

    private func mapAnimationTypeToYMKAnimationType(_ type: MapTransitionAnimationType) -> YMKAnimationType {
        let ymkAnimationType: YMKAnimationType = type == .linear ? .linear : .smooth
        return ymkAnimationType
    }
    
    func setupCameraListener(in view: YMKMapView) {
        view.mapWindow.map.addCameraListener(with: self)
    }
}

extension YandexMapViewModel: YMKMapObjectTapListener {
    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        onAnnotationDidTap?(mapObject.userData)
        return true
    }
}

extension YandexMapViewModel: YMKUserLocationObjectListener {
    func onObjectAdded(with view: YMKUserLocationView) {
        guard let viewModel = userLocationViewModel else { return }
        view.arrow.setIconWith(viewModel.arrowDirectionIcon)
        view.pin.setIconWith(viewModel.pinIcon)
        view.accuracyCircle.fillColor = viewModel.radiusColor
        view.accuracyCircle.geometry = .init(center: view.accuracyCircle.geometry.center, radius: viewModel.accuracyCircleRadius)
    }

    func onObjectRemoved(with view: YMKUserLocationView) {}

    func onObjectUpdated(with view: YMKUserLocationView, event: YMKObjectEvent) {}
}

extension YandexMapViewModel: YMKMapCameraListener {
    func onCameraPositionChanged(with map: YMKMap, cameraPosition: YMKCameraPosition, cameraUpdateReason: YMKCameraUpdateReason, finished: Bool) {
        onCameraPositionChanged?(MapPoint(latitude: cameraPosition.target.latitude, longitude: cameraPosition.target.longitude))
    }
}

private enum Constants {
    static let ShymkentPolyLine = YMKPolyline(
        points: [
            YMKPoint(latitude: 42.34517891311695, longitude: 69.50908088183532),
            YMKPoint(latitude: 42.380313451969386, longitude: 69.52470206713805),
            YMKPoint(latitude: 42.387921232511964, longitude: 69.55165290331969),
            YMKPoint(latitude: 42.38373706729813, longitude: 69.58255195117125),
            YMKPoint(latitude: 42.38373706729813, longitude: 69.60315131640563),
            YMKPoint(latitude: 42.384624640798584, longitude: 69.62993049121032),
            YMKPoint(latitude: 42.38849177888856, longitude: 42.38849177888856),
            YMKPoint(latitude: 42.38563899514845, longitude: 69.66134452319274),
            YMKPoint(latitude: 42.36198759693794, longitude: 69.73112487292418),
            YMKPoint(latitude: 42.31424553666617, longitude: 69.67160129046569),
            YMKPoint(latitude: 42.30912816615637, longitude: 69.65521835780272),
            YMKPoint(latitude: 42.29943972549621, longitude: 69.64467191195617),
            YMKPoint(latitude: 42.282090439438065, longitude: 69.67267417407164),
            YMKPoint(latitude: 42.27237402217843, longitude: 69.61491012072692),
            YMKPoint(latitude: 69.61491012072692, longitude: 69.57225226855407),
            YMKPoint(latitude: 42.30729533227581, longitude: 69.55366992449889),
            YMKPoint(latitude: 42.319418021668206, longitude: 69.53834914660582),
        ]
    )
}
