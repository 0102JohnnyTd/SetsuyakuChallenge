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
    @IBOutlet private weak var signUpButton: UIButton!

    @IBAction private func didTapRegistButton(_ sender: Any) {
        signUp()
    }

    // ハードコーディング対策
    static let storyboardName = "SignUp"
    static let identifier = "SignUp"

    // 同じ処理を一括で実行する為に複数のtextFieldを一つのプロパティにまとめる
    private var textFields: [UITextField] { [emailTextField, passwordTextField, userNameTextField] }

    // FirebaseFirestore(データの保存/取得など)を管理するモデルのインスタンスを生成して格納
    private let firebaseFirestoreManager = FirebaseFirestoreManager()

    // FirebaseAuthentication周り(アカウントの作成など)の処理を管理するモデルにインスタンスを生成して格納
    private let firebaseAuthManager = FirebaseAuthManager()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkIsLogin()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextFileds()
        setUpButton()
    }


    // アカウントを登録
    private func signUp() {
        // textFieldに値が存在することで実行できるメソッドである為、強制アンラップ
           // それでもguard letを使うべきか悩んだが、コードを簡潔にする書き方を選択
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let userName = userNameTextField.text!

        firebaseAuthManager.createUser(email: email, password: password, completion: { result in
            switch result {
            case .success:
                self.firebaseFirestoreManager.saveUserData(email: email, name: userName, completion: { result in
                    switch result {
                    case .success:
                        self.dismiss(animated: true)
                    case .failure:
                        // 後ほどエラー処理追加
                        break
                    }
                })
            case .failure(let error):
                print("認証情報の保存に失敗しました: \(error)")
                let message = self.firebaseAuthManager.getSignUpErrorMessage(error: error)
                self.showSignUpErrorAlert(message: message)
            }
        })
    }

    // ログイン状態の場合、SignUpViewControllerをdismissで終了する
    private func checkIsLogin() {
        if Auth.auth().currentUser != nil {
            dismiss(animated: true)
        } else {
            print("現在ログアウト状態です")
        }
    }

    // アカウント登録失敗をユーザーに伝えるアラートを表示
    private func showSignUpErrorAlert(message: String) {
        let alertController = generateSignUpErrorAlert(title: AlertTitle.signUpError, message: message)
        self.present(alertController, animated: true)
    }

    // アカウント登録失敗をユーザーに伝えるアラートを生成
    private func generateSignUpErrorAlert(title: String, message: String?) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: AlertAction.ok, style: .default))

        return alertController
    }

    private func setUpTextFileds() {
        textFields.forEach { $0.delegate = self }
    }

    // ボタンに丸みを加えアプリのテーマカラーを設定
    private func setUpButton() {
        signUpButton.mainButton()
    }
}
// SignUpViewController上の全てのtextFieldに値が存在する場合のみ、アカウント作成を実行するボタンをタップできる
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

// delegateメソッドの実行を通知先(HomeViewController)に伝える
extension SignUpViewController {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        guard let presentationController = presentationController else {
            return
        }
        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }
}
