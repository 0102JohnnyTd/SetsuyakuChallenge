//
//  ResetPasswordViewController.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/09/20.
//

import UIKit

final class ResetPasswordViewController: UIViewController {
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var sendEmailButton: UIButton!
    
    @IBAction private func didTapButton(_ sender: Any) {
        sendResetPasswordEmail()
    }

    // FirebaseAuthentication周り(アカウントの作成など)の処理を管理するモデルにインスタンスを生成して格納
    private let firebaseAuthManager = FirebaseAuthManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextField()
        setUpButton()
    }

    // パスワードリセットを案内するメールを送信
    private func sendResetPasswordEmail() {
        guard let email = emailTextField.text else { return }
        firebaseAuthManager.sendPasswordReset(email: email, completion: { result in
            switch result {
            case .success:
                self.showEmailSendCompleteAlert(email: email)
            case .failure(let error):
                // ⛏後ほど修正
                print("送信エラーです： \(error.localizedDescription)")
            }
        })
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

    // ボタンに丸みを加えアプリのテーマカラーを設定
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
