import UIKit

public extension UIViewController {

  func addToRight(barButton: UIBarButtonItem) {
    navigationItem.rightBarButtonItems = (navigationItem.rightBarButtonItems ?? []) + [barButton]
  }
}
