//
//  AdditionalMenuTransitioningDelegate.swift
//  KTUIKit
//
//  Created by Almas Zainoldin on 7/22/20.
//  Copyright © 2020 Alabs. All rights reserved.
//

import UIKit

private enum Constants {
    static let transitionDuration: TimeInterval = 0.45
}

final class AdditionalMenuTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    var originFrame: CGRect = .zero

    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        AdditionalMenuPresentationController(originFrame: originFrame, presentedViewController: presented, presenting: presenting)
    }

    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        AdditionalMenuPresentingAnimationController(initialYPosition: originFrame.origin.y)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        AdditionalMenuDismissingAnimationController()
    }
}

final class AdditionalMenuPresentingAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    private let initialYPosition: CGFloat

    init(initialYPosition: CGFloat) {
        self.initialYPosition = initialYPosition
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        Constants.transitionDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let presentedViewController = transitionContext.viewController(forKey: .to),
            let toView = transitionContext.view(forKey: .to) else { return }
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: presentedViewController)
        containerView.addSubview(toView)
        toView.frame = CGRect(x: UIScreen.main.bounds.width, y: initialYPosition, width: .zero, height: .zero)
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                           toView.frame = finalFrame
                       }, completion: { finished in
                           transitionContext.completeTransition(finished)
                       })
    }
}

final class AdditionalMenuDismissingAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        Constants.transitionDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                           fromView.transform = CGAffineTransform(scaleX: 0, y: 0)
                       }, completion: { finished in
                           fromView.removeFromSuperview()
                           transitionContext.completeTransition(finished)
                       })
    }
}
