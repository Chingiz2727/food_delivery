import UIKit

public extension UIView {

  func roundTopCorners(radius: CGFloat) {
    layer.cornerRadius = radius
    layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
  }

  func roundBottomCorners(radius: CGFloat) {
    layer.cornerRadius = radius
    layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
  }
}
