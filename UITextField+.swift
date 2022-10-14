//
//  UITextField+.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/09/01.
//

import UIKit

extension UITextField {
    // textFieldへの入力値をInt型に変換
    var textToInt: Int? {
        text.flatMap { Int($0) }
    }
}
