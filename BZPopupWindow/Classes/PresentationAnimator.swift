//
//  PresentationAnimator.swift
//  BZPopupWindow
//
//  Created by Banghua Zhao on 10/25/19.
//

import Foundation

class PresentationAnimator: NSObject {
    let animationType: DDPopupWindowAnimationType
    let isPresentation: Bool

    init(animationType: DDPopupWindowAnimationType, isPresentation: Bool) {
        self.animationType = animationType
        self.isPresentation = isPresentation
        super.init()
    }
}

extension PresentationAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let key: UITransitionContextViewControllerKey = isPresentation ? .to : .from
        guard let controller = transitionContext.viewController(forKey: key) else { return }
        let containerView = transitionContext.containerView
        if isPresentation {
            containerView.addSubview(controller.view)
        }

        let presentedAnimation = {
            controller.view.snp.removeConstraints()
            controller.view.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            containerView.layoutIfNeeded()
            controller.view.alpha = 1.0
            controller.view.transform = CGAffineTransform.identity
        }
        let dismissedAnimation = animationBlock(animationType: animationType, controller: controller, containerView: containerView)

        let initialAnimation = isPresentation ? dismissedAnimation : presentedAnimation
        let finalAnimation = isPresentation ? presentedAnimation : dismissedAnimation

        initialAnimation()
        let animationDuration = animationType == .none ? 0.0 : transitionDuration(using: transitionContext)
        UIView.animate(withDuration: animationDuration, animations: {
            finalAnimation()
        }, completion: { finished in
            if !self.isPresentation {
                controller.view.removeFromSuperview()
            }
            transitionContext.completeTransition(finished)
        })
    }

    func animationBlock(animationType: DDPopupWindowAnimationType, controller: UIViewController, containerView: UIView) -> (() -> Void) {
        var animationTypeBlock = {}
        switch animationType {
        case .none:
            animationTypeBlock = {
                controller.view.snp.makeConstraints { make in make.center.equalToSuperview() }
            }
        case .fade:
            animationTypeBlock = {
                controller.view.snp.makeConstraints { make in make.center.equalToSuperview() }
            }
        case .zoom:
            animationTypeBlock = {
                controller.view.snp.makeConstraints { make in make.center.equalToSuperview() }
                controller.view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }
        case .translationTop:
            animationTypeBlock = {
                controller.view.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.centerY.equalToSuperview().offset(-containerView.bounds.height / 2)
                }
            }
        case .translationBottom:
            animationTypeBlock = {
                controller.view.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.centerY.equalToSuperview().offset(containerView.bounds.height / 2)
                }
            }
        case .translationLeft:
            animationTypeBlock = {
                controller.view.snp.makeConstraints { make in
                    make.centerX.equalToSuperview().offset(-containerView.bounds.width / 2)
                    make.centerY.equalToSuperview()
                }
            }
        case .translationRight:
            animationTypeBlock = {
                controller.view.snp.makeConstraints { make in
                    make.centerX.equalToSuperview().offset(containerView.bounds.width / 2)
                    make.centerY.equalToSuperview()
                }
            }
        }
        return {
            controller.view.snp.removeConstraints()
            animationTypeBlock()
            controller.view.alpha = 0.0
            containerView.layoutIfNeeded()
        }
    }
}
