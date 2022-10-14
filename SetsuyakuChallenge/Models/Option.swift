//
//  Option.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/12.
//

import Foundation

// ユーザーの詳細画面でセルに表示するオプションのモデル
struct Option {
    // メニュー名
    var item: String
    // 文字のカラー
    var textColorType: TextColorType
}

enum TextColorType {
    case normal
    case warning
}
