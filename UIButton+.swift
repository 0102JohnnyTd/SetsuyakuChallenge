//
//  UIButton+.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/31.
//

import UIKit

extension UIButton {
    // ボタンに丸みを加え、アプリのテーマカラーを設定
    func mainButton() {
        self.backgroundColor = .mainColor()
        self.layer.cornerRadius = 5
    }
}
