import UIKit

protocol DimmingViewTappedProtocol: AnyObject {
  func dimmingViewTapped()
}

extension DimmingViewTappedProtocol where Self: UIViewController {
  func dimmingViewTapped() {
    dismiss(animated: true, completion: nil)
  }
}
