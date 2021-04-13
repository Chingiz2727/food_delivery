import UIKit

extension UIView {

  public func takeScreenshot() -> UIImage? {

    UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)

    drawHierarchy(in: self.bounds, afterScreenUpdates: true)

    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return image
  }
}
