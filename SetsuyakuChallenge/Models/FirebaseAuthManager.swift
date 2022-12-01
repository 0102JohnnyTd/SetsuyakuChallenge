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
//                self.getSignUpErrorMessage(error: error)
                completion(.failure(error))
//                print("認証情報の保存に失敗しました: \(err)")
//                self.showSignUpErrorAlert(err: err)
//                return
            }
            completion(.success(()))
            // ユーザー作成が完了したらFirestoreにユーザーデータを保存
//            print("認証情報の保存に成功しました")
//            self.firebaseFirestoreManager.saveUserData(email: email, name: userName, completion: { result in
//                switch result {
//                case .success:
//                    self.dismiss(animated: true)
//                case .failure:
//                    break
//                }
//            })
        }
    }
    // MARK: - アカウント削除
    // MARK: - ログイン機能
    // MARK: - ログアウト機能
    // MARK: - パスワード再設定案内のメール送信
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

