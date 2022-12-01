//
//  FirebaseAuthManager.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/11/30.
//

import Foundation
import FirebaseAuth

final class FirebaseAuthManager {
    // MARK: - アカウント作成
    // アカウントを登録
    // ❓SuccessパターンにVoidを指定するのはOKなのだろうか。
    func createUser(email: String, password: String, completion: @escaping (Result<(), NSError>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if let error = error as NSError? {
                completion(.failure(error))
            }
            completion(.success(()))
        }
    }
    // MARK: - アカウント削除
    // MARK: - ログイン機能
    // MARK: - ログアウト機能
    // MARK: - パスワード再設定案内のメール送信
    // MARK: - ログイン状態をチェック
    // ログイン状態の場合、SignUpViewControllerをdismissで終了する
    func checkIsLogin(completion: () -> Void) {
        if Auth.auth().currentUser != nil {
            completion()
        }
    }
    // MARK: - ログアウト状態をチェック
    // ログアウト状態の場合、SignUpViewControllerを表示するメソッドを実行する
    func checkIsLogout(completion: () -> Void) {
        if Auth.auth().currentUser == nil {
            completion()
        }
    }

    // MARK: - エラーを返す処理
    func getSignUpErrorMessage(error: NSError) -> String {
        if let errCode = AuthErrorCode(rawValue: error.code) {
            switch errCode {
            case .invalidEmail:      return AlertMessage.invalidEmail
            case .emailAlreadyInUse: return AlertMessage.emailAlreadyInUse
            case .weakPassword:      return AlertMessage.weakPassword
            default:                 return AlertMessage.someErrors
            }
        }
        // この書き方違和感なんだけどこれ書かないとエラーが出る。switchで網羅してるわけだから絶対ここに辿り着くことないはず。
        return ""
    }
}
