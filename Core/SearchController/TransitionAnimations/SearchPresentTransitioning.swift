import UIKit

class SearchPresentTransitioning: NSObject, UIViewControllerAnimatedTransitioning {

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.3
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

    let containerView = transitionContext.containerView

    guard
      let fromVC = transitionContext.viewController(forKey: .from),
      let toVC = transitionContext.viewController(forKey: .to) as? SearchImage
      else {
        transitionContext.completeTransition(true)
        return
    }

    let snapshot = fromVC.view.takeScreenshot()

    containerView.addSubview(toVC.view)
    toVC.view.frame = containerView.frame
    toVC.backgroundImageView.image = snapshot
    toVC.view.layoutIfNeeded()

    let snapshotView = UIImageView(image: snapshot)
    snapshotView.contentMode = toVC.backgroundImageView.contentMode
    snapshotView.clipsToBounds = toVC.backgroundImageView.clipsToBounds

    containerView.addSubview(snapshotView)
    snapshotView.frame = containerView.frame

    let blurEffectView: UIView = toVC.blurEffectView.deepCopy()
    blurEffectView.alpha = 0
    snapshotView.addSubview(blurEffectView)

    let duration = transitionDuration(using: transitionContext)
    UIView.animate(
      withDuration: duration,
      animations: {
        blurEffectView.alpha = toVC.blurEffectView.alpha
        snapshotView.frame = toVC.backgroundImageView.frame
        snapshotView.layer.cornerRadius = toVC.backgroundImageView.layer.cornerRadius
      },
      completion: { _ in

        snapshotView.removeFromSuperview()

        transitionContext.completeTransition(true)
      }
    )
  }
}
