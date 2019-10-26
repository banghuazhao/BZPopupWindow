//
//  Color.swift
//  Pods-BZPopupWindow_Example
//
//  Created by Banghua Zhao on 10/26/19.
//

import UIKit

extension Int {
    func duplicate4bits() -> Int {
        return (self << 4) + self
    }
}

extension UIColor {
    private convenience init(hex6: Int, alpha: Float) {
        self.init(red: CGFloat((hex6 & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((hex6 & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat((hex6 & 0x0000FF) >> 0) / 255.0, alpha: CGFloat(alpha))
    }

    convenience init(hex: Int, alpha: Float) {
        self.init(hex6: hex, alpha: alpha)
    }

    convenience init(hex: Int) {
        self.init(hex: hex, alpha: 1.0)
    }
}

extension UIColor {
    static let titleColor: UIColor = UIColor(hex: 0x000000)
    static let messageColor: UIColor = UIColor(hex: 0x333333)
    static let backgroundColor: UIColor = UIColor(hex: 0xFFFFFF)
    static let whiteTextColor: UIColor = UIColor(hex: 0xFFFFFF)
}
