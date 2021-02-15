import UIKit

@objc public enum NavigationBarType: Int {
  case primary
  case secondary
}

public protocol NavigationBarConfigurable {
  func navigationBarType() -> NavigationBarType

  var navigationBarHidden: Bool { get }
}

extension UIViewController: NavigationBarConfigurable {
  @objc open func navigationBarType() -> NavigationBarType { .primary }

  @objc open var navigationBarHidden: Bool { false }
}

extension BackContainerViewController {
  override var navigationBarHidden: Bool { true }
}

extension BackButtonContainerViewController {
  override var navigationBarHidden: Bool { true }
}
