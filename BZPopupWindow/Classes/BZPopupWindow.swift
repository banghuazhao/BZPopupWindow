//
//  BZPopupWindow.swift
//  BZPopupWindow
//
//  Created by Banghua Zhao on 10/25/19.
//

import UIKit

import SnapKit

open class BZPopupWindow: UIViewController {
    // MARK: - Properties

    public var attributedTitle: NSAttributedString?
    public var attributedMessage: NSAttributedString?
    public var image: UIImage?
    public var imageSize: CGSize = CGSize(width: 80, height: 80)
    public var actions = [BZPopupAction]()
    
    open var titleAligment: NSTextAlignment = .center
    open var messageAligment: NSTextAlignment = .center
    
    open var width: CGFloat = 310
    open var edgeInset: CGFloat = 25
    
    private var contentWidth: CGFloat {
        return width - 2*edgeInset
    }

    private var presentationManager = PresentationManager()

    private var tempWindow: BZWindow?

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()

    private var customContentView: UIView?

    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.snp.makeConstraints { make in
            make.width.equalTo(260)
        }
        stackView.spacing = 10
        return stackView
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        return imageView
    }()

    private lazy var attributedTitleTextView: CustomTextView = CustomTextView()

    private lazy var attributedMessageTextView: CustomTextView = CustomTextView()

    // MARK: - init related

    /// - Popup window with custom title and message
    /// - Parameter image: optional
    /// - Parameter imageSize: 40x40px to120x120px
    /// - Parameter title: custom title by attributed string
    /// - Parameter message: custom message by attributed string
    public init(image: UIImage? = nil,
                imageSize: CGSize = CGSize(width: 80, height: 80),
                title: NSAttributedString,
                message: NSAttributedString) {
        super.init(nibName: nil, bundle: nil)
        self.image = image
        self.imageSize = imageSize
        if (40 ... 120 ~= imageSize.width) == false || (40 ... 120 ~= imageSize.height) == false {
            print("Warning: image size is invalid")
        }
        attributedTitle = title
        attributedMessage = message
        modalPresentationStyle = .custom
        transitioningDelegate = presentationManager
    }

    /// - Popup window with title and message
    /// - Parameter image: optional
    /// - Parameter imageSize: 40x40px to120x120px
    /// - Parameter title: string
    /// - Parameter message: string
    public convenience init(image: UIImage? = nil,
                            imageSize: CGSize = CGSize(width: 80, height: 80),
                            title: String, message: String) {
        let title = NSAttributedString(string: title, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .bold),
            NSAttributedString.Key.foregroundColor: UIColor.titleColor])
        let message = NSAttributedString(string: message, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
            NSAttributedString.Key.foregroundColor: UIColor.messageColor,])
        self.init(image: image, imageSize: imageSize, title: title, message: message)
    }

    /// - Popup window with title and custom view
    /// - Parameter title: string
    /// - Parameter customContentView: 自定义view
    public init(title: String? = nil,
                customContentView: UIView) {
        super.init(nibName: nil, bundle: nil)
        if let title = title {
            attributedTitle = NSAttributedString(string: title, attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .bold),
                NSAttributedString.Key.foregroundColor: UIColor.titleColor])
        }
        self.customContentView = customContentView
        modalPresentationStyle = .custom
        transitioningDelegate = presentationManager
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - view life cycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if let customContentView = customContentView as? UIScrollView {
            customContentView.flashScrollIndicators()
        }
    }

    deinit {
        print("\(#function): \(type(of: self))")
    }

    // MARK: - UI related

    func setupUI() {
        view.backgroundColor = UIColor.backgroundColor
        view.layer.cornerRadius = 10
        view.snp.makeConstraints { make in
            make.width.equalTo(width)
        }

        // add stack view
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(edgeInset)
        }

        // add image
        if image != nil {
            imageView.image = image
            imageView.snp.makeConstraints { make in
                make.height.equalTo(imageSize.height)
                make.width.equalTo(contentWidth)
            }
            stackView.addArrangedSubview(imageView)
            stackView.addArrangedSubview(SpaceView(height: 20, width: contentWidth))
        }

        // add attribuated title
        if attributedTitle != nil {
            attributedTitleTextView.attributedText = attributedTitle
            attributedTitleTextView.textAlignment = titleAligment
            stackView.addArrangedSubview(attributedTitleTextView)
            stackView.addArrangedSubview(SpaceView(height: 10, width: contentWidth))
        }

        // add attribuated message
        if attributedMessage != nil {
            attributedMessageTextView.attributedText = attributedMessage
            attributedMessageTextView.textAlignment = messageAligment
            stackView.addArrangedSubview(attributedMessageTextView)
        }

        // add custom content view
        if let customContentView = customContentView {
            stackView.addArrangedSubview(customContentView)
        }

        // add action buttons
        if !actions.isEmpty {
            var buttonWidth: CGFloat = contentWidth
            if actions.count == 2 {
                buttonStackView.axis = .horizontal
                buttonWidth = ( contentWidth - 10 ) / 2
            } else {
                buttonStackView.axis = .vertical
            }
            for action in actions {
                let button = BZPopupActionButton()
                button.popupAction = action
                button.snp.makeConstraints { make in
                    make.width.equalTo(buttonWidth)
                }
                buttonStackView.addArrangedSubview(button)
                button.addTarget(self, action: #selector(actionButtonTapped(_:)), for: .touchUpInside)
            }
            stackView.addArrangedSubview(SpaceView(height: 20, width: contentWidth))
            stackView.addArrangedSubview(buttonStackView)
        }
    }

    @objc func actionButtonTapped(_ button: BZPopupActionButton) {
        if let handler = button.handler {
            handler()
        }
        dismiss(animated: true, completion: nil)
    }

    // MARK: - public methods

    public func addAction(_ action: BZPopupAction) {
        actions.append(action)
    }

    public func addActions(_ actions: [BZPopupAction]) {
        for action in actions {
            self.actions.append(action)
        }
    }

    public func show(animationType: DDPopupWindowAnimationType = .fade, tapBackgroundDismiss: Bool = true, completion: (() -> Void)?) {
        tempWindow = BZWindow()
        tempWindow?.rootViewController = TempWindowRootVC()
        presentationManager.animationType = animationType
        presentationManager.tapBackgroundDismiss = tapBackgroundDismiss
        tempWindow?.rootViewController?.present(self, animated: true, completion: completion)
    }
}
