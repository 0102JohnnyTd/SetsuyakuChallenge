//
//  Challenge.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/26.
//

import Foundation
import UIKit

// チャレンジのモデル
struct Challenge: Codable {
    // 目標の画像
    var imageURL: String
    // 目標の名称
    var name: String
    // 目標金額
    var goalAmount: Int
    // 節約メモのリスト
    var reports: [SaveMoneyReport]
    // 合計節約金額
    var totalSavingAmount: Int
    // 目標達成済みか否かを判断するBool値
    var isChallenge: Bool
    // Challengesコレクションのどのチャレンジなのかを識別するドキュメントID
    var docID: String?
}
