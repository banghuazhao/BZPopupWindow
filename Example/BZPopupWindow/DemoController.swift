//
//  DemoController.swift
//  BZPopupWindow
//
//  Created by banghuazhao on 10/26/2019.
//  Copyright (c) 2019 banghuazhao. All rights reserved.
//

import UIKit

import BZPopupWindow
import SnapKit
import UIKit

class DemoController: UIViewController {
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 30
        return stackView
    }()

    lazy var basicButton: CustomButton = {
        let button = CustomButton(title: "basic example")
        button.addTarget(self, action: #selector(basicDemo), for: .touchDown)
        return button
    }()

    lazy var showButton: CustomButton = {
        let button = CustomButton(title: "show method")
        button.addTarget(self, action: #selector(showDemo), for: .touchDown)
        return button
    }()

    lazy var doubleButton: CustomButton = {
        let button = CustomButton(title: "double button")
        button.addTarget(self, action: #selector(doubleDemo), for: .touchDown)
        return button
    }()

    lazy var customContentViewButton: CustomButton = {
        let button = CustomButton(title: "Custom Content View")
        button.addTarget(self, action: #selector(customContentViewDemo), for: .touchDown)
        return button
    }()

    lazy var animationTypeButton: CustomButton = {
        let button = CustomButton(title: "Custom Animation Type")
        button.addTarget(self, action: #selector(animationTypeDemo), for: .touchDown)
        return button
    }()
    
    lazy var customSizeButton: CustomButton = {
        let button = CustomButton(title: "Custom Size Type")
        button.addTarget(self, action: #selector(customSizeDemo), for: .touchDown)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white

        view.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300)
        }

        stackView.addArrangedSubview(basicButton)
        stackView.addArrangedSubview(showButton)
        stackView.addArrangedSubview(doubleButton)
        stackView.addArrangedSubview(customContentViewButton)
        stackView.addArrangedSubview(animationTypeButton)
        stackView.addArrangedSubview(customSizeButton)
    }

    @objc func basicDemo() {
        let image = UIImage(named: "correct.png")
        let title = "TitleTitleTitle"
        let message = "MessageMessageMessageMessageMessageMessageMessageMessageMessageMessageMessage"
        let popupWindow = BZPopupWindow(image: image, imageSize: CGSize(width: 80, height: 80), title: title, message: message)
        let action = BZPopupAction(title: "Ok")
        popupWindow.addAction(action)
        present(popupWindow, animated: true, completion: nil)
    }

    @objc func showDemo() {
        let title = "TitleTitleTitle"
        let message = "MessageMessageMessageMessageMessageMessageMessageMessageMessageMessageMessage"
        let popupWindow = BZPopupWindow(title: title, message: message)
        popupWindow.messageAligment = .left
        popupWindow.show(completion: nil)
    }

    @objc func doubleDemo() {
        let title = "TitleTitleTitle"
        let attributedTitle = NSAttributedString(string: title, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .bold),
            NSAttributedString.Key.foregroundColor: UIColor.black])

        let message = "MessageMessageMessageMessageMessageMessageMessageMessageMessageMessageMessageClickHereMessageMessageMessageMessageMessageMessageMessageMessageMessageMessageMessage"
        let attributedMessage: NSMutableAttributedString = NSMutableAttributedString(string: message)
        let clickHereTange = (attributedMessage.string as NSString).range(of: "ClickHere")
        attributedMessage.addAttribute(NSAttributedString.Key.link, value: "https://github.com/", range: clickHereTange)
        attributedMessage.addAttributes([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
            NSAttributedString.Key.foregroundColor: UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)]
        , range: NSRange(location: 0, length: attributedMessage.string.count))

        let popupWindow = BZPopupWindow(title: attributedTitle, message: attributedMessage)
        let action1 = BZPopupAction(title: "Cancel", style: .cancel)
        let action2 = BZPopupAction(title: "Ok") {
            print("Ok")
        }
        popupWindow.addAction(action1)
        popupWindow.addAction(action2)
        present(popupWindow, animated: true, completion: nil)
    }


    @objc func customContentViewDemo() {
        let customView = UIScrollView()
        customView.snp.makeConstraints { make in
            make.width.equalTo(260)
            make.height.equalTo(300)
        }

        let messageLabel = UILabel(frame: .zero)

        customView.addSubview(messageLabel)

        messageLabel.text = "AgreementAgreementAgreementAgreementAgreementAgreementAgreementAgreementAgreementAgreementAgreement\n\nAgreementAgreementAgreementAgreementAgreementAgreementAgreementAgreementAgreementAgreementAgreement\n\nAgreementAgreementAgreementAgreementAgreementAgreementAgreementAgreementAgreementAgreementAgreement\n\nAgreementAgreementAgreementAgreementAgreementAgreementAgreementAgreementAgreementAgreementAgreement"
        messageLabel.textAlignment = .left
        messageLabel.font = UIFont.systemFont(ofSize: 15)
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping
        messageLabel.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(customView.snp.top)
            make.width.equalTo(260)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }

        let popupWindow = BZPopupWindow(title: "Term of Use", customContentView: customView)

        let action1 = BZPopupAction(title: "Agree", color: .orange)
        let action2 = BZPopupAction(title: "Disagree", color: .orange, style: .cancel)

        popupWindow.addAction(action1)
        popupWindow.addAction(action2)
        popupWindow.show(completion: nil)
    }

    @objc func animationTypeDemo() {
        let title = "TitTitleTitle"
        let message = "AnimationFromBottomAnimationFromBottomAnimationFromBottomAnimationFromBottomAnimationFromBottomAnimationFromBottomAnimationFromBottomAnimationFromBottomAnimationFromBottomAnimationFromBottomAnimationFromBottomAnimationFromBottomAnimationFromBottomAnimationFromBottomAnimation"
        let popupWindow = BZPopupWindow(image: nil, imageSize: CGSize(width: 60, height: 60), title: title, message: message)
        let action = BZPopupAction(title: "Ok")
        popupWindow.addAction(action)
//        popupWindow.show(completion: nil) // default animation
        popupWindow.show(animationType: .bottom, completion: nil) // transition from bottom
    }
    
    @objc func customSizeDemo() {
        let title = "TitTitleTitle"
        let message = "AnimationFromBottomAnimationFromBottomAnimationFromBottomAnimationFromBottomAnimationFromBottomAnimationFromBottomAnimationFromBottomAnimationFromBottomAnimationFromBottomAnimationFromBottomAnimationFromBottomAnimationFromBottomAnimationFromBottomAnimationFromBottomAnimation"
        let popupWindow = BZPopupWindow(image: nil, imageSize: CGSize(width: 60, height: 60), title: title, message: message)
        popupWindow.edgeInset = 24
        popupWindow.width = 320
        popupWindow.messageAligment = .left
        popupWindow.show(animationType: .fade, completion: nil) // transition from bottom
    }
}

class CustomButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setTitleColor(UIColor.white, for: .normal)
        backgroundColor = UIColor.systemBlue
        layer.cornerRadius = 10
        snp.makeConstraints { make in
            make.width.equalTo(300)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
