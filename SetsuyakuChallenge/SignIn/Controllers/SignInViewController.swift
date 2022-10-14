//
//  SignInViewController.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/22.
//

import UIKit
import FirebaseAuth

final class SignInViewController: UIViewController {
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var signInButton: UIButton!
    
    @IBAction private func didTapSignInButton(_ sender: Any) {
        login()
    }

    // 同じ処理を一括で実行する為に複数のtextFieldを一つのプロパティにまとめる
    private var textFields: [UITextField] { [emailTextField, passwordTextField] }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextFields()
        setUpButton()
    }

    // ログインを実行
    private func login() {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        Auth.auth().signIn(withEmail: email, password: password) { _, err in
            if let err = err as NSError? {
                print("ログイン情報の取得に失敗しました")
                self.showLoginErrorAlert(err: err)
                return
            }
            print("ログイン情報の取得に成功しました")
            self.navigationController?.popViewController(animated: true)
        }
    }

    // ログイン失敗をユーザーに伝えるアラートを表示
    private func showLoginErrorAlert(err: NSError) {
        if let errCode = AuthErrorCode(rawValue: err.code) {
            var message: String
            // ケースに応じてエラーメッセージを切り替える
            switch errCode {
            case .userNotFound:  message = AlertMessage.userNotFound
            case .wrongPassword: message = AlertMessage.wrongPassword
            case .invalidEmail:  message = AlertMessage.invalidEmail
            default:             message = AlertMessage.someErrors
            }
            let alertController = generateLoginErrorAlert(title: AlertTitle.loginError, message: message)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    // ログイン失敗をユーザーに伝えるアラートを生成
    private func generateLoginErrorAlert(title: String, message: String?) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: AlertAction.ok, style: .default))

        return alertController
    }

    private func setUpTextFields() {
        textFields.forEach { $0.delegate = self }
    }

    // ボタンに丸みを加えアプリのテーマカラーを設定する
    private func setUpButton() {
        signInButton.mainButton()
    }
}

// SignInViewController上の全てのtextFieldに値が存在する場合のみ、アカウント作成を実行するボタンをタップできる
extension SignInViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let textsIsEmpty = textFields.map { $0.text?.isEmpty ?? true }

        if textsIsEmpty[0] || textsIsEmpty[1] {
            signInButton.isEnabled = false
        } else {
            signInButton.isEnabled = true
        }
    }
}
