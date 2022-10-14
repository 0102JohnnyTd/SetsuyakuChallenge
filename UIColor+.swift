//
//  UIColor+.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/20.
//

import UIKit

extension UIColor {
    // ❓写経状態でなぜclass funcをチョイスしたかを理解できていないため、要確認
    // RGB値でカラーを指定できるメソッドを追加
    class func rgb(r: Int, g: Int, b: Int, alpha: CGFloat) -> UIColor {
        UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }

    // アプリのテーマカラー(赤)を返す
    class func mainColor() -> UIColor {
        UIColor.rgb(r: 217, g: 77, b: 75, alpha: 1)
    }

    // アプリのサブカラー(緑)を返す
    class func subColor() -> UIColor {
        UIColor.rgb(r: 100, g: 217, b: 171, alpha: 1)
    }
}
