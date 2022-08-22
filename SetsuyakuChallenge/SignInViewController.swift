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
    @IBOutlet private weak var loginButton: UIButton!

    private var textFields: [UITextField] { [emailTextField, passwordTextField] }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextFields()
    }

    private func setUpTextFields() {
        textFields.forEach { $0.delegate = self }
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
