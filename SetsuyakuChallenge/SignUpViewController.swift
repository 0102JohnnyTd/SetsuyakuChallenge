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
        let userName = userNameTextField.text!

        Auth.auth().createUser(withEmail: email, password: password) { [self] (res, err) in
            if let err = err {
                print("認証情報の保存に失敗しました: \(err)")
                return
            }
            print("認証情報の保存に成功しました")
            saveData(email: email, userName: userName)
        }
    }

    private func saveData(email: String, userName: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let docData = ["email": email, "userName": userName, "createdAt": Timestamp()] as [String: Any]
        let userRef = Firestore.firestore().collection("users").document(uid)

        userRef.setData(docData) { (err) in
            if let err = err {
                print("FireStroreへの保存に失敗しました: \(err)")
            }
            print("FireStoreへの保存に成功しました")
            self.loadData(uid: uid, userRef: userRef)
        }
    }

    private func loadData(uid: String, userRef: DocumentReference) {
        userRef.getDocument { (snapshot, err) in
            if let err = err {
                print("ユーザー情報の取得に失敗しました \(err)")
            }
            let data = snapshot?.data()
            print("ユーザー情報の取得に成功しました: \(data)")
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
