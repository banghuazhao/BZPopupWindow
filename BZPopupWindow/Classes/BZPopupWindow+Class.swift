//
//  BZPopupWindow+Class.swift
//  BZPopupWindow
//
//  Created by Banghua Zhao on 10/25/19.
//

import UIKit

// MARK: - BZPopupAction

public class BZPopupAction {
    
    public let title: String?
    public let color: UIColor?
    public let style: Style
    public enum Style {
        case `default`
        case cancel
    }
    var handler: (() -> Void)?
    
    public init(title: String, color: UIColor = UIColor.systemBlue, style: Style = .default, handler: (() -> Void)? = nil) {
        self.title = title
        self.color = color
        self.style = style
        self.handler = handler
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


// MARK: - SpaceView

class SpaceView: UIView {
    init(height: CGFloat, width: CGFloat) {
        super.init(frame: .zero)
        snp.makeConstraints { make in
            make.height.equalTo(height)
            make.width.equalTo(width)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - CustomTextView

class CustomTextView: UITextView {
    override var canBecomeFirstResponder: Bool {
        return false
    }

    init() {
        super.init(frame: .zero, textContainer: nil)
        backgroundColor = UIColor.backgroundColor
        textContainerInset = .zero
        textContainer.lineFragmentPadding = 0
        isEditable = false
        isScrollEnabled = false

        guard let textViewGestureRecognizers = self.gestureRecognizers else { return }
        for textViewGestureRecognizer in textViewGestureRecognizers {
            if textViewGestureRecognizer.isKind(of: UILongPressGestureRecognizer.self) {
                textViewGestureRecognizer.isEnabled = false
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - DDActionButton

class BZPopupActionButton: UIButton {
    var popupAction: BZPopupAction? {
        didSet {
            setTitle(popupAction?.title, for: .normal)
            if popupAction?.style == .default {
                backgroundColor = popupAction?.color
                setTitleColor(UIColor.whiteTextColor, for: .normal)
            } else {
                backgroundColor = UIColor.backgroundColor
                setTitleColor(popupAction?.color, for: .normal)
                layer.borderWidth = 1
                layer.borderColor = popupAction?.color?.cgColor
            }
            handler = popupAction?.handler
        }
    }

    var handler: (() -> Void)?

    init() {
        super.init(frame: .zero)
        snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        layer.cornerRadius = 22
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BZWindow: UIWindow {
    init() {
        super.init(frame: .zero)
        frame = UIScreen.main.bounds
        backgroundColor = .clear
        makeKeyAndVisible()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("\(#function): \(type(of: self)), number of windows: \(UIApplication.shared.windows.count)")
    }
}

class TempWindowRootVC: UIViewController {
}
