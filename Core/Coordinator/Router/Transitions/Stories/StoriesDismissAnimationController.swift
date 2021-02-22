import UIKit

private enum Constants {
    static let transitionDuration = 0.3
}

public final class StoriesDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    private let destinationFrame: CGRect

    init(destinationFrame: CGRect) {
        self.destinationFrame = destinationFrame
    }

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        Constants.transitionDuration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let originView = transitionContext.view(forKey: .from) else { return }

        let originFrame = originView.frame
        let xScaleFactor = destinationFrame.width / originFrame.width
        let yScaleFactor = destinationFrame.height / originFrame.height
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)

        let animations: Callback = {
            originView.transform = scaleTransform
            originView.center = CGPoint(x: self.destinationFrame.midX, y: self.destinationFrame.midY)
            originView.alpha = 0.0
        }

        UIView.animate(withDuration: Constants.transitionDuration,
                       delay: 0.0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 0.0,
                       animations: animations) { _ in transitionContext.completeTransition(true) }
    }
}
