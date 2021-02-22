//
//  Router+Transitions.swift
//  KTUIKit
//
//  Created by Almas Zainoldin on 7/8/20.
//  Copyright © 2020 Alabs. All rights reserved.
//

import UIKit

extension Router {
    private static var storiesTransitioningDelegate = StoriesTransitionDelegate()
    private static var slidingTransitioningDelegate = SlidingTransitioningDelegate()
    private static var dropdownTransitioningDelegate = DropdownTransitioningDelegate()
    private static var additionalMenuTransitioningDelegate = AdditionalMenuTransitioningDelegate()

    public func presentStories(_ module: Presentable?, animated: Bool, originFrame: CGRect) {
        guard let controller = module?.toPresent() else { return }
        Router.storiesTransitioningDelegate.originFrame = originFrame
        controller.transitioningDelegate = Router.storiesTransitioningDelegate
        controller.modalPresentationCapturesStatusBarAppearance = true
        present(module, animated: animated, modalPresentationStyle: .custom)
    }

    public func presentInSlidingCard(_ module: Presentable?, animated: Bool) {
        guard let controller = module?.toPresent() else { return }
        controller.transitioningDelegate = Router.slidingTransitioningDelegate
        present(module, animated: animated, modalPresentationStyle: .custom)
    }

    public func presentDropdown(_ module: DropdownPresentable?) {
        guard let controller = module?.toPresent() else { return }
        controller.transitioningDelegate = Router.dropdownTransitioningDelegate
        present(module, animated: true, modalPresentationStyle: .custom)
    }

    public func presentAdditionalMenu(_ module: Presentable, originFrame: CGRect) {
        guard let controller = module.toPresent() else { return }
        Router.additionalMenuTransitioningDelegate.originFrame = originFrame
        controller.transitioningDelegate = Router.additionalMenuTransitioningDelegate
        present(module, animated: true, modalPresentationStyle: .custom)
    }
}
