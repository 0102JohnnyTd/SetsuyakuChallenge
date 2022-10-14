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
        signUp()
    }

    // ハードコーディング対策
    static let storyboardName = "SignUp"
    static let identifier = "SignUp"

    // 同じ処理を一括で実行する為に複数のtextFieldを一つのプロパティにまとめる
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


    // アカウントを登録
    private func signUp() {
        // textFieldに値が存在することで実行できるメソッドである為、強制アンラップ
           // それでもguard letを使うべきか悩んだが、コードを簡潔にする書き方を選択
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let userName = userNameTextField.text!

        Auth.auth().createUser(withEmail: email, password: password) { [self] (res, err) in
            if let err = err as NSError? {
                print("認証情報の保存に失敗しました: \(err)")
                self.showSignUpErrorAlert(err: err)
                return
            }
            print("認証情報の保存に成功しました")
            saveData(email: email, name: userName)
        }
    }

    // Firestore上にデータの保存を行う
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

    // ログイン状態の場合、SignUpViewControllerをdismissで終了する
    private func checkIsLogin() {
        if Auth.auth().currentUser != nil {
            dismiss(animated: true)
        } else {
            print("現在ログアウト状態です")
        }
    }

    // アカウント登録失敗をユーザーに伝えるアラートを表示
    private func showSignUpErrorAlert(err: NSError) {
        // ケースに応じてエラーメッセージを切り替える
        if let errCode = AuthErrorCode(rawValue: err.code) {
            var message: String
            switch errCode {
            case .invalidEmail:      message = AlertMessage.invalidEmail
            case .emailAlreadyInUse: message = AlertMessage.emailAlreadyInUse
            case .weakPassword:      message = AlertMessage.weakPassword
            default:                 message = AlertMessage.someErrors
            }
            let alertController = generateSignUpErrorAlert(title: AlertTitle.signUpError, message: message)
            self.present(alertController, animated: true)
        }
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

    // ボタンに丸みを加えアプリのテーマカラーを設定する
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
