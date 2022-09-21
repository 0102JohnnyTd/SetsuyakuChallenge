//
//  AlertManager.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/09/02.
//

import Foundation


enum AlertTitle {
    static let inputError = "入力エラー"
    static let targetaAchievement = "🎉おめでとう🎉"
    static let emailSendComplete = "メール送信完了"
    static let loginError = "ログインに失敗しました"
}

enum AlertMessage {
    static let inputError = "金額は数値以外の値を入れないでください"
    static let targetaAchievement = "の貯金が貯まりました🥳"
    static let emailSendComplete = "にメールを送信しました"
    static let userNotFound = "アカウントが見つかりませんでした"
    static let wrongPassword = "パスワードが一致しませんでした"
    static let invalidEmail = "メールアドレスが無効な形式です"
}

enum AlertAction {
    static let ok = "OK"
}
