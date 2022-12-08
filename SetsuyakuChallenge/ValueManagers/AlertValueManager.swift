//
//  AlertValueManager.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/09/02.
//

import Foundation


enum AlertTitle {
    static let inputError = "入力エラー"
    static let targetaAchievement = "🎉おめでとう🎉"
    static let emailSendComplete = "メール送信完了"
    static let loginError = "ログインに失敗"
    static let signUpError = "アカウント作成に失敗"
    static let countOverError = "チャレンジ数が上限に達しました"
    static let saveDataError = "データの保存に失敗// Firestorageへ画像の保存が失敗した場合、クロージャにNSError型の値を渡して実行"
}

enum AlertMessage {
    static let inputError = "金額は数値以外の値を入れないでください"
    static let targetaAchievement = "の貯金が貯まりました🥳"
    static let emailSendComplete = "にメールを送信しました"
    static let userNotFound = "アカウントが見つかりませんでした"
    static let weakPassword = "パスワードは6文字以上で入力してください"
    static let wrongPassword = "パスワードが一致しませんでした"
    static let invalidEmail = "メールアドレスが無効な形式です"
    static let emailAlreadyInUse = "登録済みのメールアドレスです"
    static let someErrors = "エラーが発生しました。"
    static let countOverError = "同時に登録できるチャレンジ数は2つまでです"
    static let alreadyExists = "作成しようとしたドキュメントがすでに存在しています"
}

enum AlertAction {
    static let ok = "OK"
    static let cancel = "閉じる"
    static let retry = "もう一度試す"
}
