import UIKit

public protocol MapStatus: class {
    associatedtype MapView: UIView
    
    var userLocationViewModel: MapUserLocationViewModel? { get set }
    var onAnnotationDidTap: ((_ data: Any?) -> Void)? { get set }
    
    func showCurrentLocation(in view: MapView)
    func moveTo(in view: MapView, point: MapPoint, transitionViewModel: MapTransitionViewModel, completionHandler: Callback?)
    func setRegion(in view: MapView, minPoint: MapPoint, maxPoint: MapPoint, transitionViewModel: MapTransitionViewModel, completionHandler: Callback?)
    func createAnnotation(in view: MapView, at point: MapPoint, image: UIImage?, associatedData: Any?)
}
