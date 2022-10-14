//
//  User.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/11.
//

import Foundation

// ユーザーのモデル
struct User: Codable {
    // メールアドレス
    let email: String
    // ユーザー名
    let name: String
}
