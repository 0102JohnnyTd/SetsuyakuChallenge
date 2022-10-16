//
//  CreateSaveMoneyReportViewController.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/30.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

final class CreateSaveMoneyReportViewController: UIViewController {
    // ⛏priceではなく、amountで統一したほうが良いかも。
    @IBOutlet private weak var priceSwicth: UISwitch!
    @IBOutlet private weak var priceTextField: UITextField!
    @IBOutlet private weak var memoTextView: UITextView!
    @IBOutlet private weak var createReportButton: UIButton!
    
    @IBAction private func didTapButton(_ sender: Any) {
        saveReportData()
        navigationController?.popViewController(animated: true)
    }

    // SaveMoneyReportListで取得したchallengeデータを受け取るためのプロパティ
    var challenge: Challenge?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButton()
        setUpTextView()
        setUpTextFiled()
    }

    // 作成した節約メモをFireStoreに保存
    private func saveReportData() {
        let inputPrice = priceTextField.textToInt
        let memo = memoTextView.text ?? ""
        guard let price = inputPrice else {
            showAlert()
            return
        }

        // switchがオンの場合は+符号の値を返し、オフの場合は-符号の値を返す
        let signPrice = priceSwicth.isOn ? price : -price

        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let  challengeDocID = challenge?.docID else { return }

        let saveMoneyReport = SaveMoneyReport(savingAmount: signPrice, memo: memo)

        // Firestore上のchallengeのフィールドである配列reportsにメモを要素として追加
        challenge?.reports.append(saveMoneyReport)

        let challegenRef = Firestore.firestore().collection(CollectionName.users).document(uid).collection(CollectionName.challenges).document(challengeDocID)
        do {
            try challegenRef.setData(from: challenge)
        } catch {
            print("error: \(error.localizedDescription)")
        }
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
