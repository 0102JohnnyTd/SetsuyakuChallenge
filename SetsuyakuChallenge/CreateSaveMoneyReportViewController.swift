//
//  CreateSaveMoneyReportViewController.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/30.
//

import UIKit

class CreateSaveMoneyReportViewController: UIViewController {

    @IBOutlet private weak var priceSwicth: UISwitch!

    @IBOutlet private weak var priceTextField: UITextField!

    @IBOutlet private weak var memoTextView: UITextView!

    @IBOutlet private weak var createReportButton: UIButton!

    @IBAction private func didTapButton(_ sender: Any) {
        checkIsTextFieldPrice()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButton()
        setUpTextView()
        setUpTextFiled()
    }

    private func checkIsTextFieldPrice() {
        let inputPrice = priceTextField.textToInt

        guard let price = inputPrice else {
            showAlert()
            return
        }
        let signPrice = priceSwicth.isOn ? price : -price
        createReport(price: signPrice)
    }

    private func createReport(price: Int) {
        let saveMoneyReport = SaveMoneyReport(price: price, memo: memoTextView.text!)
        SaveMoneyReport.array.append(saveMoneyReport)
    }

    private func showAlert() {
        let alertController = generateInputErrorAlert()
        present(alertController, animated: true)
    }
    private func generateInputErrorAlert() -> UIAlertController {
        let alertController =  UIAlertController(title: "入力エラー", message: "金額は数値以外の値を入れてないでください", preferredStyle: .alert)
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
