import UIKit

private enum Constants {
    static let transitionDuration = 0.5
}

public final class StoriesPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    private let originFrame: CGRect

    init(originFrame: CGRect) {
        self.originFrame = originFrame
    }

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        Constants.transitionDuration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let destinationView = transitionContext.view(forKey: .to) else { return }

        let containerView = transitionContext.containerView
        let destinationFrame = destinationView.frame
        let xScaleFactor = originFrame.width / destinationFrame.width
        let yScaleFactor = originFrame.height / destinationFrame.height
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)

        destinationView.transform = scaleTransform
        destinationView.center = CGPoint(x: originFrame.midX, y: originFrame.midY)
        destinationView.clipsToBounds = true
        containerView.addSubviewMatchParent(destinationView)
        containerView.bringSubviewToFront(destinationView)

        let animations: Callback = {
            destinationView.transform = .identity
            destinationView.center = CGPoint(x: destinationFrame.midX, y: destinationFrame.midY)
        }

        UIView.animate(withDuration: Constants.transitionDuration,
                       delay: 0.0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 0.0,
                       animations: animations) { _ in transitionContext.completeTransition(true) }
    }
}
