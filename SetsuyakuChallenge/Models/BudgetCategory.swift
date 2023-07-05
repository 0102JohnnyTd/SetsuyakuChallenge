//
//  BudgetCategory.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2023/07/05.
//

import Foundation

/// 費目
struct BudgetCategory {
    /// 費目名
    var name: String
    /// 費目の予算
    var budget: Int
    /// 費目のサブカテゴリー
    var ExpenseItem: [BudgetCategory]
}
