//
//  SignInViewController.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/22.
//

import UIKit

final class SignInViewController: UIViewController {
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var signInButton: UIButton!
    
    @IBAction private func didTapSignInButton(_ sender: Any) {
        login()
    }

    // FirebaseAuthentication周り(アカウントの作成など)の処理を管理するモデルにインスタンスを生成して格納
    private let firebaseAuthManager = FirebaseAuthManager()

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

        firebaseAuthManager.signIn(email: email, password: password, completion: { result in
            switch  result {
            case .success:
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                self.showLoginErrorAlert(error: error)
            }
        })
    }

    // ログイン失敗をユーザーに伝えるアラートを表示
    private func showLoginErrorAlert(error: NSError) {
        let message = firebaseAuthManager.getSignInErrorMessage(error: error)
        let alertController = generateLoginErrorAlert(title: AlertTitle.loginError, message: message)
        self.present(alertController, animated: true, completion: nil)
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

    // ボタンに丸みを加えアプリのテーマカラーを設定
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
