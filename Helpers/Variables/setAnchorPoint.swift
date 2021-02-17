import UIKit

public extension UIView {
    func setAnchorPoint(_ point: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var olKToint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)

        newPoint = newPoint.applying(transform)
        olKToint = olKToint.applying(transform)

        var position = layer.position

        position.x -= olKToint.x
        position.x += newPoint.x

        position.y -= olKToint.y
        position.y += newPoint.y

        layer.position = position
        layer.anchorPoint = point
    }
}
