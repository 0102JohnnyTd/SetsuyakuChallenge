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
}

enum AlertMessage {
    static let inputError = "金額は数値以外の値を入れないでください"
    static let targetaAchievement = "の貯金が貯まりました🥳"
    static let emailSendComplete = "にメールを送信しました"
}

enum AlertAction {
    static let ok = "OK"
}
