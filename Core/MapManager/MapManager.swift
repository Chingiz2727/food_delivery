import UIKit

open class MapManager<T: MapStatus> {
    var userLocationViewModel: MapUserLocationViewModel? {
        didSet {
            engine.userLocationViewModel = userLocationViewModel
        }
    }
    
    var onAnnotationDidTap: ((Any?) -> Void)? {
        didSet {
            engine.onAnnotationDidTap = onAnnotationDidTap
        }
    }
    
    var onCameraPositionChanged: ((MapPoint?) -> Void)? {
        didSet {
            engine.onCameraPositionChanged = onCameraPositionChanged
        }
    }

    private var engine: T

    init(engine: T) {
        self.engine = engine
    }
    
    func showCurrentLocation(in view: T.MapView) {
        engine.showCurrentLocation(in: view)
    }
    
    func moveTo(in view: T.MapView, point: MapPoint, transitionViewModel: MapTransitionViewModel, completionHandler: Callback? = nil) {
        engine.moveTo(in: view, point: point, transitionViewModel: transitionViewModel, completionHandler: completionHandler)
    }
    
    func setRegion(in view: T.MapView, minPoint: MapPoint, maxPoint: MapPoint, transitionViewModel: MapTransitionViewModel, completionHandler: Callback? = nil) {
        engine.setRegion(in: view, minPoint: minPoint, maxPoint: maxPoint, transitionViewModel: transitionViewModel, completionHandler: completionHandler)
    }
    
    func createAnnotation(in view: T.MapView, at point: MapPoint, image: UIImage?, associatedData: Any?) {
        engine.createAnnotation(in: view, at: point, image: image, associatedData: associatedData)
    }
    
    func getDistance(firstPoint: MapPoint, secondPoint: MapPoint) -> Double {
        engine.getDistance(firstPoint: firstPoint, secondPoint: secondPoint)
    }
    
    func setupCameraListener(in view: T.MapView) {
        engine.setupCameraListener(in: view)
    }
}
