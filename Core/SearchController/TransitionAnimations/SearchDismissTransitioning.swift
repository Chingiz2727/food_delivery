import UIKit

class SearchDismissTransitioning: NSObject, UIViewControllerAnimatedTransitioning {

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.3
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

    let containerView = transitionContext.containerView

    guard let fromVC = transitionContext.viewController(forKey: .from) as? SearchImage else {
      transitionContext.completeTransition(true)
      return
    }

    let snapshotView = UIImageView(image: fromVC.backgroundImageView.image)
    snapshotView.contentMode = fromVC.backgroundImageView.contentMode
    snapshotView.layer.cornerRadius = fromVC.backgroundImageView.layer.cornerRadius
    snapshotView.clipsToBounds = fromVC.backgroundImageView.clipsToBounds

    let blurEffectView: UIView = fromVC.blurEffectView.deepCopy()
    snapshotView.addSubview(blurEffectView)

    containerView.addSubview(snapshotView)
    snapshotView.frame = fromVC.backgroundImageView.frame

    let duration = transitionDuration(using: transitionContext)
    UIView.animate(
      withDuration: duration,
      animations: {
        blurEffectView.alpha = 0
        snapshotView.frame = containerView.frame
        snapshotView.layer.cornerRadius = 0
      },
      completion: { _ in

        snapshotView.removeFromSuperview()
        fromVC.view.removeFromSuperview()

        transitionContext.completeTransition(true)
      }
    )
  }
}
