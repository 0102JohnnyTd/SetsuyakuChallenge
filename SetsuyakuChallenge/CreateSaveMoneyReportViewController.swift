//
//  CreateSaveMoneyReportViewController.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/30.
//

import UIKit

class CreateSaveMoneyReportViewController: UIViewController {
    @IBOutlet private weak var priceTextField: UITextField!

    @IBOutlet private weak var memoTextView: UITextView!

    @IBOutlet private weak var createReportButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButton()
        setUpTextView()
        setUpTextFiled()
    }

    private func createReport(price: Int) {
        let saveMoneyReport = SaveMoneyReport(price: price, memo: memoTextView.text!)

        SaveMoneyReport.array.append(saveMoneyReport)
    }

    private func generateInputErrorAlert() -> UIAlertController {
        let alertController =  UIAlertController(title: "入力エラー", message: "浮いた金額には数値を入れてください", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))

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
