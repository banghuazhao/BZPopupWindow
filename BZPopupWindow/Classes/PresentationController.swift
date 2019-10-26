//
//  PresentationController.swift
//  BZPopupWindow
//
//  Created by Banghua Zhao on 10/25/19.
//

import UIKit

class PresentationController: UIPresentationController {
    private let animationType: DDPopupWindowAnimationType
    private var tapBackgroundDismiss: Bool
    lazy var backgroundView = UIView()

    init(presentedViewController: UIViewController,
         presenting presentingViewController: UIViewController?,
         animationType: DDPopupWindowAnimationType,
         tapBackgroundDismiss: Bool) {
        self.animationType = animationType
        self.tapBackgroundDismiss = tapBackgroundDismiss
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupBackgroundView()
    }

    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        containerView.insertSubview(backgroundView, at: 0)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.backgroundView.alpha = 1.0
        }, completion: nil)
    }

    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.backgroundView.alpha = 0.0
        }, completion: nil)
    }
}

extension PresentationController {
    func setupBackgroundView() {
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backgroundView.alpha = 0.0
        if tapBackgroundDismiss {
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapBackground(_:)))
            backgroundView.addGestureRecognizer(tapRecognizer)
        }
    }

    @objc func handleTapBackground(_ sender: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
}
