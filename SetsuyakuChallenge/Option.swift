//
//  Option.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/12.
//

import Foundation

struct Option {
    var item: String
    var textColorType: TextColorType
}

enum TextColorType {
    case normal
    case warning
}
