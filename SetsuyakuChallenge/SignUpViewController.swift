//
//  SignUpViewController.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/10.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

final class SignUpViewController: UIViewController {
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var signUpButton: UIButton!

    @IBAction private func didTapRegistButton(_ sender: Any) {
        registUser()
    }

    static let storyboardName = "SignUp"
    static let identifier = "SignUp"

    private var textFields: [UITextField] { [emailTextField, passwordTextField, userNameTextField] }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkIsLogin()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextFileds()
        setUpButton()
    }

    private func registUser() {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let userName = userNameTextField.text!

        Auth.auth().createUser(withEmail: email, password: password) { [self] (res, err) in
            if let err = err {
                print("認証情報の保存に失敗しました: \(err)")
                return
            }
            print("認証情報の保存に成功しました")
            saveData(email: email, name: userName)
        }
    }

    private func saveData(email: String, name: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let user = User(email: email, createdAt: Timestamp(), name: name)

        let userRef = Firestore.firestore().collection(CollectionName.users).document(uid)

        do {
            try userRef.setData(from: user)
            print("FireStoreへの保存に成功しました")
            self.dismiss(animated: true)
        } catch {
            print("FireStroreへの保存に失敗しました: \(error.localizedDescription)")
        }
    }

    private func checkIsLogin() {
        if Auth.auth().currentUser != nil {
            dismiss(animated: true)
        } else {
            print("現在ログアウト状態です")
        }
    }

    private func setUpTextFileds() {
        textFields.forEach { $0.delegate = self }
    }
    private func setUpButton() {
        signUpButton.mainButton()
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let textsIsEmpty = textFields.map { $0.text?.isEmpty ?? true }

        if textsIsEmpty[0] || textsIsEmpty[1] || textsIsEmpty[2] {
            signUpButton.isEnabled = false
        } else {
            signUpButton.isEnabled = true
        }
    }
}

extension SignUpViewController {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        guard let presentationController = presentationController else {
            return
        }
        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }
}
