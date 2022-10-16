//
//  SaveMoneyReport.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/31.
//

import Foundation

// 節約メモのモデル
struct SaveMoneyReport: Codable {
    // 節約できた金額
    var savingAmount: Int
    // 節約の詳細メモ
    var memo: String
}
