//
//  UIColor+.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/20.
//

import UIKit

extension UIColor {
    class func rgb(r: Int, g: Int, b: Int, alpha: CGFloat) -> UIColor {
        UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }

    class func mainColor() -> UIColor {
        UIColor.rgb(r: 217, g: 77, b: 75, alpha: 1)
    }
}
