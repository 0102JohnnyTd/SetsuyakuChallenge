//
//  ResetPasswordViewController.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/09/20.
//

import UIKit
import FirebaseAuth

final class ResetPasswordViewController: UIViewController {
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var sendEmailButton: UIButton!
    @IBAction private func didTapButton(_ sender: Any) {
        sendResetPasswordEmail()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextField()
        setUpButton()
    }

    // パスワードリセットを案内するメールを送信
    private func sendResetPasswordEmail() {
        guard let email = emailTextField.text else { return }
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("送信エラーです： \(error.localizedDescription)")
            } else {
                self.showEmailSendCompleteAlert(email: email)
            }
        }
    }

    // パスワードリセットを案内するメール送信完了をユーザーに伝えるアラートを表示
    private func showEmailSendCompleteAlert(email: String) {
        let alertController = generateEmailSendCompleteAlert(email: email)
        present(alertController, animated: true)
    }

    //  パスワードリセットを案内するメール送信完了をユーザーに伝えるアラートを生成
    private func generateEmailSendCompleteAlert(email: String) -> UIAlertController {
        let alertController = UIAlertController(title: AlertTitle.emailSendComplete, message: email + AlertMessage.emailSendComplete, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: AlertAction.ok, style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })

        return alertController
    }

    private func setUpTextField() {
        emailTextField.delegate = self
    }

    // ボタンに丸みを加えアプリのテーマカラーを設定する
    private func setUpButton() {
        sendEmailButton.mainButton()
    }
}

// SignUpViewController上の全てのtextFieldに値が存在する場合のみ、アカウント作成を実行するボタンをタップできる
extension ResetPasswordViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let email = emailTextField.text else { return }

        if email.isEmpty {
            sendEmailButton.isEnabled = false
        } else {
            sendEmailButton.isEnabled = true
        }
    }
}
