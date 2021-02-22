//
//  SlidingPresentationController.swift
//  KTUIKit
//
//  Created by Almas Zainoldin on 7/8/20.
//  Copyright © 2020 Alabs. All rights reserved.
//

import UIKit

private enum Constants {
    static let dimmingViewAlphaComponent: CGFloat = 0.4
}

public final class SlidingPresentationController: UIPresentationController {
    public override var frameOfPresentedViewInContainerView: CGRect {
        guard let resolver = containerView else { return .zero }
        return CGRect(x: 0,
                      y: resolver.bounds.height - presentedViewController.preferredContentSize.height,
                      width: resolver.bounds.width,
                      height: presentedViewController.preferredContentSize.height)
    }

    private lazy var dimmingView: UIView? = {
        guard let containerView = containerView else { return nil }
        let view = UIView(frame: containerView.bounds)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dimmingViewDidTap)))
        view.backgroundColor = UIColor.black.withAlphaComponent(Constants.dimmingViewAlphaComponent)
        return view
    }()

    public override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }

    public override func presentationTransitionWillBegin() {
        guard
            let containerView = containerView,
            let coordinator = presentingViewController.transitionCoordinator,
            let dimmingView = dimmingView else { return }
        containerView.addSubview(dimmingView)
        dimmingView.alpha = 0
        dimmingView.addSubview(presentedViewController.view)
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.dimmingView?.alpha = 1
        }, completion: nil)
    }

    public override func preferredContentSizeDidChange(forChildContentContainer resolver: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: resolver)
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    public override func dismissalTransitionWillBegin() {
        guard let coordinator = presentingViewController.transitionCoordinator else { return }
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.dimmingView?.alpha = 0
        }, completion: nil)
    }

    public override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView?.removeFromSuperview()
        }
    }

    @objc
    private func dimmingViewDidTap() {
        presentedViewController.dismiss(animated: true)
    }
}
