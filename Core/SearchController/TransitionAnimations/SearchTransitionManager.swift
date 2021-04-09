import UIKit

public class SearchTransitionManager: NSObject, UIViewControllerTransitioningDelegate {

  public func animationController(
    forPresented presented: UIViewController,
    presenting: UIViewController,
    source: UIViewController
  ) -> UIViewControllerAnimatedTransitioning? {
    SearchPresentTransitioning()
  }

  public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    SearchDismissTransitioning()
  }

  public func presentationController(
    forPresented presented: UIViewController,
    presenting: UIViewController?,
    source: UIViewController
  ) -> UIPresentationController? {
    SearchPresentationController(presentedViewController: presented, presenting: presenting)
  }
}
