//
//  CreateSaveMoneyReportViewController.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/30.
//

import UIKit
import FirebaseFirestore

final class CreateSaveMoneyReportViewController: UIViewController {
    @IBOutlet private weak var priceSwicth: UISwitch!

    @IBOutlet private weak var priceTextField: UITextField!

    @IBOutlet private weak var memoTextView: UITextView!

    @IBOutlet private weak var createReportButton: UIButton!

    @IBAction private func didTapButton(_ sender: Any) {
        checkIsTextFieldPrice()
        navigationController?.popViewController(animated: true)
    }

    private let priceManager = PriceManager.shared

    var challenge: Challenge?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButton()
        setUpTextView()
        setUpTextFiled()
    }

    private func checkIsTextFieldPrice() {
        let inputPrice = priceTextField.textToInt
        let memo = memoTextView.text ?? ""

        guard let price = inputPrice else {
            showAlert()
            return
        }
        let signPrice = priceSwicth.isOn ? price : -price
        priceManager.calculate(price: signPrice)


        let docData = [SaveMoneyReportsDocDataKey.savingAmount: signPrice, SaveMoneyReportsDocDataKey.memo: memo] as [String: Any]

        guard let  challengeDocID = challenge?.docID else { return }
        Firestore.firestore().collection(CollectionName.challenges).document(challengeDocID).collection(CollectionName.reports).document().setData(docData) { err in
            if let err = err {
                print("Firestoreへの保存に失敗しました: \(err)")
            }
            print("Firestoreへの保存に成功しました")
        }
//        createReport(price: signPrice)
    }


//    private func createReport(price: Int) {
//        let saveMoneyReport = SaveMoneyReport(savingAmount: price, memo: memoTextView.text!)
//        SaveMoneyReport.array.append(saveMoneyReport)
//    }

    private func showAlert() {
        let alertController = generateInputErrorAlert()
        present(alertController, animated: true)
    }
    private func generateInputErrorAlert() -> UIAlertController {
        let alertController =  UIAlertController(title: AlertTitle.inputError, message: AlertMessage.inputError, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: AlertAction.ok, style: .default))

        return alertController
    }

    private func setUpButton() {
        createReportButton.mainButton()
    }
    private func setUpTextFiled() {
        priceTextField.delegate = self
        setUpNumberPad()
    }
    private func setUpNumberPad() {
        priceTextField.keyboardType = .numberPad
    }
    private func setUpTextView() {
        memoTextView.layer.cornerRadius = 5
    }
}

extension CreateSaveMoneyReportViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if priceTextField.text?.isEmpty ?? true {
            createReportButton.isEnabled = false
        } else {
            createReportButton.isEnabled = true
        }
    }
}
