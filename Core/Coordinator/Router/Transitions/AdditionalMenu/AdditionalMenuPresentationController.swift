//
//  AdditionalMenuPresentationController.swift
//  KTUIKit
//
//  Created by Almas Zainoldin on 7/22/20.
//  Copyright © 2020 Alabs. All rights reserved.
//

import UIKit

private enum Constants {
    static let dimmingViewAlphaComponent: CGFloat = 0.45
    static let tabBarHeight: CGFloat = 49
}

final class AdditionalMenuPresentationController: UIPresentationController {
    private var originFrame: CGRect = .zero
    private lazy var dimmingView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewDidTap)))
        view.backgroundColor = UIColor.black.withAlphaComponent(Constants.dimmingViewAlphaComponent)
        return view
    }()

    override var frameOfPresentedViewInContainerView: CGRect {
        let originY: CGFloat = originFrame.origin.y - presentedViewController.preferredContentSize.height
        let originX: CGFloat = UIScreen.main.bounds.width - presentedViewController.preferredContentSize.width - 16
        return CGRect(x: originX,
                      y: originY,
                      width: presentedViewController.preferredContentSize.width,
                      height: presentedViewController.preferredContentSize.height)
    }

    convenience init(originFrame: CGRect, presentedViewController: UIViewController, presenting: UIViewController?) {
        self.init(presentedViewController: presentedViewController, presenting: presenting)
        self.originFrame = originFrame
    }

    override func presentationTransitionWillBegin() {
        guard
            let containerView = containerView,
            let coordinator = presentingViewController.transitionCoordinator else { return }
        containerView.frame = CGRect(origin: containerView.frame.origin,
                                     size: CGSize(width: containerView.frame.width, height: containerView.frame.height - getTabBarHeight()))
        dimmingView.frame = CGRect(origin: .zero, size: CGSize(width: containerView.bounds.width, height: containerView.bounds.height))
        containerView.addSubview(dimmingView)
        dimmingView.addSubview(presentedViewController.view)
        dimmingView.alpha = 0
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.dimmingView.alpha = 1
        }, completion: nil)
    }

    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    override func dismissalTransitionWillBegin() {
        guard
            let coordinator = presentingViewController.transitionCoordinator else { return }
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.dimmingView.alpha = 0
        }, completion: nil)
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        guard completed else { return }
        dimmingView.removeFromSuperview()
    }

    private func getTabBarHeight() -> CGFloat {
        if #available(iOS 11.0, *) {
            return Constants.tabBarHeight + presentingViewController.view.safeAreaInsets.bottom
        } else {
            return Constants.tabBarHeight
        }
    }

    @objc
    private func viewDidTap() {
        presentedViewController.dismiss(animated: true)
    }
}
