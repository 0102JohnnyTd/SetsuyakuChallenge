//
//  CreateSaveMoneyReportViewController.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/30.
//

import UIKit

final class CreateSaveMoneyReportViewController: UIViewController {
    // ⛏priceではなく、amountで統一したほうが良いかも。
    @IBOutlet private weak var priceSwicth: UISwitch!
    @IBOutlet private weak var priceTextField: UITextField!
    @IBOutlet private weak var memoTextView: UITextView!
    @IBOutlet private weak var createReportButton: UIButton!
    
    @IBAction private func didTapButton(_ sender: Any) {
        saveReportData()
    }

    // SaveMoneyReportListで取得したchallengeデータを受け取るためのプロパティ
    var challenge: Challenge?

    private let calculator = Calculator()
    // FirebaseFirestore(データの保存/取得など)を管理するモデルのインスタンスを生成して格納
    private let firebaseFirestoreManager = FirebaseFirestoreManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButton()
        setUpTextView()
        setUpTextFiled()
        setUpFirebaseFirestoreManager()
    }

    // 作成した節約メモをFireStoreに保存
    private func saveReportData() {
        let inputPrice = priceTextField.textToInt
        guard let price = inputPrice else {
            showAlert()
            return
        }
        let memo = memoTextView.text ?? ""
        // switchがオンの場合は+符号の値を返し、オフの場合は-符号の値を返す
        let signPrice = priceSwicth.isOn ? price : -price

        firebaseFirestoreManager.saveReportData(challenge: challenge, memo: memo, price: signPrice)
    }

    // ユーザーが金額を入力する箇所に数値型以外の値を入力した場合にエラーを伝えるアラートを表示
    private func showAlert() {
        let alertController = generateInputErrorAlert()
        present(alertController, animated: true)
    }

    // ユーザーが金額を入力する箇所に数値型以外の値を入力した場合にエラーを伝えるアラートを生成
    private func generateInputErrorAlert() -> UIAlertController {
        let alertController =  UIAlertController(title: AlertTitle.inputError, message: AlertMessage.inputError, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: AlertAction.ok, style: .default))

        return alertController
    }

    // ボタンに丸みを加えアプリのテーマカラーを設定
    private func setUpButton() {
        createReportButton.mainButton()
    }
    private func setUpTextFiled() {
        priceTextField.delegate = self
        setUpNumberPad()
    }

    // priceTextFieldのキーボードタイプを数値入力型に変換
    private func setUpNumberPad() {
        priceTextField.keyboardType = .numberPad
    }

    // TextViewに丸みを加える
    private func setUpTextView() {
        memoTextView.layer.cornerRadius = 5
    }

    private func setUpFirebaseFirestoreManager() {
        firebaseFirestoreManager.delegate = self
    }
}

extension CreateSaveMoneyReportViewController: FirebaseFirestoreManagerDelegate {
    func didSaveData() {
        navigationController?.popViewController(animated: true)
    }
}
// priceTextFieldに値が入力されている時のみ、レポート作成ボタンをタップすることができる
extension CreateSaveMoneyReportViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if priceTextField.text?.isEmpty ?? true {
            createReportButton.isEnabled = false
        } else {
            createReportButton.isEnabled = true
        }
    }
}
