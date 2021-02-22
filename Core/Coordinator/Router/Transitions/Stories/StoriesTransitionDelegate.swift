//
//  StoriesTransitionDelegate.swift
//  KTUIKit
//
//  Created by Almas Zainoldin on 7/6/20.
//  Copyright © 2020 Alabs. All rights reserved.
//

import UIKit

public final class StoriesTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    var originFrame: CGRect?

    public func animationController(forPresented presented: UIViewController,
                                    presenting: UIViewController,
                                    source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let originFrame = originFrame else { return nil }
        return StoriesPresentAnimationController(originFrame: originFrame)
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let originFrame = originFrame else { return nil }
        return StoriesDismissAnimationController(destinationFrame: originFrame)
    }
}
