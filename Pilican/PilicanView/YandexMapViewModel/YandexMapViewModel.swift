import CoreLocation
import YandexMapsMobile

final class YandexMapViewModel: NSObject, MapStatus {
    
    typealias MapView = YMKMapView

    var userLocationViewModel: MapUserLocationViewModel?
    
    var onAnnotationDidTap: ((Any?) -> Void)?
    
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
