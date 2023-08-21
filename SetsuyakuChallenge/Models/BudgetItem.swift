//
//  Emoji.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2023/08/20.
//

import Foundation

/// 費目のアイコンや名前を管理する
enum BudgetItem {
    case transport
    case food
    case dailyNecessities

    /// 表示するアイコン
    var icon: String {
        switch self {
        case .transport: return "🚃"
        case .food: return "🍙"
        case .dailyNecessities: return "🧻"
        }
    }

    /// 表示する費目名
    var name: String {
        switch self {
        case .transport: return "交通"
        case .food: return "食事"
        case .dailyNecessities: return "日用品"
        }
    }
}
