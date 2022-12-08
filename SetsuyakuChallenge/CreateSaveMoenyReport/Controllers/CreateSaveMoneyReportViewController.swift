//
//  CreateSaveMoneyReportViewController.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/30.
//

import UIKit

final class CreateSaveMoneyReportViewController: UIViewController {
    // ⛏priceではなく、amountで統一したほうが良いかも?
    @IBOutlet private weak var priceSwicth: UISwitch!
    @IBOutlet private weak var priceTextField: UITextField!
    @IBOutlet private weak var memoTextView: UITextView!
    @IBOutlet private weak var createReportButton: UIButton!
    
    @IBAction private func didTapButton(_ sender: Any) {
        saveReportData()
    }

    // SaveMoneyReportListで取得したchallengeデータを受け取るためのプロパティ
    var challenge: Challenge?

    // FirebaseFirestore(データの保存/取得など)を管理するモデルのインスタンスを生成して格納
    private let firebaseFirestoreManager = FirebaseFirestoreManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButton()
        setUpTextView()
        setUpTextFiled()
    }

    // 作成した節約メモをFireStoreに保存
    private func saveReportData() {
        let inputPrice = priceTextField.textToInt
        guard let price = inputPrice else {
            showInputErrorAlert()
            return
        }
        let memo = memoTextView.text ?? ""
        // switchがオンの場合は+符号の値を返し、オフの場合は-符号の値を返す
        let signPrice = priceSwicth.isOn ? price : -price

        firebaseFirestoreManager.saveReportData(challenge: challenge, memo: memo, price: signPrice, completion: { [weak self] result in
            switch result {
            case .success:
                self?.navigationController?.popViewController(animated: true)
            case .failure(let error):
                showSaveDataErrorAlert(error: error)
            }
        })
    }

    // データの保存失敗時に表示するアラートを表示
    private func showSaveDataErrorAlert(error: NSError) {
        let errorMessage = firebaseFirestoreManager.getSaveDataErrorMessage(error: error)
        let alertController = UIAlertController(title: AlertTitle.saveDataError, message: errorMessage, preferredStyle: .alert)

        // ボタンをタップすると再度保存を実行する
        alertController.addAction(UIAlertAction(title: AlertAction.retry, style: .default, handler: { [weak self] _ in
            self?.saveReportData() }))
        alertController.addAction(UIAlertAction(title: AlertAction.cancel, style: .default))
        present(alertController, animated: true)
    }

    // ユーザーが金額を入力する箇所に数値型以外の値を入力した場合にエラーを伝えるアラートを表示
    private func showInputErrorAlert() {
        let alertController =  UIAlertController(title: AlertTitle.inputError, message: AlertMessage.inputError, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: AlertAction.ok, style: .default))

        present(alertController, animated: true)
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
