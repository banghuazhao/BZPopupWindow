//
//  PresentationManager.swift
//  BZPopupWindow
//
//  Created by Banghua Zhao on 10/25/19.
//

import UIKit

public enum DDPopupWindowAnimationType {
    case none
    case fade
    case zoom
    case translationLeft
    case translationRight
    case translationTop
    case translationBottom
}

final class PresentationManager: NSObject {
    var animationType: DDPopupWindowAnimationType = .fade
    var tapBackgroundDismiss: Bool = true
}

extension PresentationManager: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController,
                                       presenting: UIViewController?,
                                       source: UIViewController) -> UIPresentationController? {
        let presentationController = PresentationController(presentedViewController: presented, presenting: presenting, animationType: animationType, tapBackgroundDismiss: tapBackgroundDismiss)
        return presentationController
    }

    public func animationController(forPresented presented: UIViewController,
                                    presenting: UIViewController,
                                    source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentationAnimator(animationType: animationType, isPresentation: true)
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentationAnimator(animationType: animationType, isPresentation: false)
    }
}
