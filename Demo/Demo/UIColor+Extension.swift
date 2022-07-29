//
//  UIColor+Extension.swift
//  Demo
//
//  Created by 郑桂杰 on 2022/7/30.
//

import UIKit

extension UIColor {
    static func random() -> UIColor {
        return UIColor(hue: CGFloat(arc4random() % 256) / 256.0, saturation: CGFloat(arc4random() % 128) / 256.0 + 0.5, brightness: CGFloat(arc4random() % 128) / 256.0 + 0.5, alpha: 1)
    }
}
