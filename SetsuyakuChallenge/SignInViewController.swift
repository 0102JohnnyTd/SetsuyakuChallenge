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

    private var textFields: [UITextField] { [emailTextField, passwordTextField] }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextFields()
        setUpButton()
    }

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

    private func showLoginErrorAlert(err: NSError) {
        if let errCode = AuthErrorCode(rawValue: err.code) {
            var message: String
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

    private func generateLoginErrorAlert(title: String, message: String?) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: AlertAction.ok, style: .default))

        return alertController
    }

    private func setUpTextFields() {
        textFields.forEach { $0.delegate = self }
    }

    private func setUpButton() {
        signInButton.mainButton()
    }
}

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
