//
//  ExpenseReport.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2023/07/06.
//

import Foundation
import FirebaseFirestore

/// 支出メモ
struct ExpenseReport {
    /// 支出額
    var expense: Int
    /// メモ
    var memo:  String
    /// 作成日時
    var createdAt: Timestamp
}
