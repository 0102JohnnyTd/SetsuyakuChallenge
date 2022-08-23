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
    @IBOutlet private weak var loginButton: UIButton!
    @IBAction private func didTapLoginButton(_ sender: Any) {
        login()
    }

    private var textFields: [UITextField] { [emailTextField, passwordTextField] }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextFields()
        setUpButton()
    }
    private func login() {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            if let err = err {
                print("ログイン情報の取得に失敗しました")
                return
            }
            print("ログイン情報の取得に成功しました")
            self.dismiss(animated: true)
        }
    }

    private func setUpTextFields() {
        textFields.forEach { $0.delegate = self }
    }

    private func setUpButton() {
        loginButton.backgroundColor = .mainColor()
        loginButton.layer.cornerRadius = 5
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let textsIsEmpty = textFields.map { $0.text?.isEmpty ?? true }

        if textsIsEmpty[0] || textsIsEmpty[1] {
            loginButton.isEnabled = false
        } else {
            loginButton.isEnabled = true
        }
    }
}
