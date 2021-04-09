import UIKit

public protocol BarButtonContainerModule {

  func addBarButton(module: ToBarButtonItemConvertable)
}

public extension BarButtonContainerModule where Self: UIViewController {

  func addBarButton(module: ToBarButtonItemConvertable) {
    addToRight(barButton: module.barButtonItem)
  }
}
