//
//  SlidingTransitioningDelegate.swift
//  KTUIKit
//
//  Created by Almas Zainoldin on 7/8/20.
//  Copyright © 2020 Alabs. All rights reserved.
//

import UIKit

public final class SlidingTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController,
                                       presenting: UIViewController?,
                                       source: UIViewController) -> UIPresentationController? {
        SlidingPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
