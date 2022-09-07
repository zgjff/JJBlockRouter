//
//  UIColor+Extension.swift
//  Demo
//
//  Created by zgjff on 2022/9/7.
//

import UIKit

extension UIColor {
    /// 随机颜色
    public static func jj_random() -> UIColor {
        return UIColor(hue: CGFloat(arc4random() % 256) / 256.0, saturation: CGFloat(arc4random() % 128) / 256.0 + 0.5, brightness: CGFloat(arc4random() % 128) / 256.0 + 0.5, alpha: 1)
    }
}
