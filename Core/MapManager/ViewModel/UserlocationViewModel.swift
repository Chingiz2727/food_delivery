import UIKit

public struct MapUserLocationViewModel {
    public let pinIcon: UIImage
    public let arrowDirectionIcon: UIImage
    public let accuracyCircleRadius: Float
    public let radiusColor: UIColor
    
    public init(pinIcon: UIImage, arrowDirectionIcon: UIImage, radiusColor: UIColor, accuracyCircleRadius: Float) {
        self.pinIcon = pinIcon
        self.arrowDirectionIcon = arrowDirectionIcon
        self.accuracyCircleRadius = accuracyCircleRadius
        self.radiusColor = radiusColor
    }
}
