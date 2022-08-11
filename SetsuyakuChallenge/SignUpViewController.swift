//
//  SignUpViewController.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/10.
//

import UIKit
import FirebaseAuth

final class SignUpViewController: UIViewController {
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var registButton: UIButton!

    @IBAction private func didTapRegistButton(_ sender: Any) {
        registUser()
    }

    private var textFields: [UITextField] { [emailTextField, passwordTextField, userNameTextField] }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextFileds()
    }


    private func registUser() {
        let email = emailTextField.text!
        let password = passwordTextField.text!

        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            if let err = err {
                print("認証情報の保存に失敗しました: \(err)")
                return
            }
            print("認証情報の保存に成功しました")


        }
    }

    private func setUpTextFileds() {
        textFields.forEach { $0.delegate = self }
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let textsIsEmpty = textFields.map { $0.text?.isEmpty ?? true }

        if textsIsEmpty[0] || textsIsEmpty[1] || textsIsEmpty[2] {
            registButton.isEnabled = false
        } else {
            registButton.isEnabled = true
        }
    }
}
