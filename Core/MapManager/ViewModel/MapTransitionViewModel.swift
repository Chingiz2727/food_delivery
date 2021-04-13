import Foundation

public struct MapTransitionViewModel {
    public let duration: Float
    public let animationType: MapTransitionAnimationType
    public var zoom: Float = 1
    
    public init(duration: Float, animationType: MapTransitionAnimationType, zoom: Float) {
        self.duration = duration
        self.animationType = animationType
        self.zoom = zoom
    }
    
    public init(duration: Float, animationType: MapTransitionAnimationType) {
        self.duration = duration
        self.animationType = animationType
    }
    
}

public enum MapTransitionAnimationType {
    case linear, smooth
}
