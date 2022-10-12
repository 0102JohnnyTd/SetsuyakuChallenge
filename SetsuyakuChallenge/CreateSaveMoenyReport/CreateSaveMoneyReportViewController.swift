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
    @IBOutlet private weak var priceSwicth: UISwitch!

    @IBOutlet private weak var priceTextField: UITextField!

    @IBOutlet private weak var memoTextView: UITextView!

    @IBOutlet private weak var createReportButton: UIButton!

    @IBAction private func didTapButton(_ sender: Any) {
        saveReportData()
        navigationController?.popViewController(animated: true)
    }

    var challenge: Challenge?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButton()
        setUpTextView()
        setUpTextFiled()
    }

    private func saveReportData() {
        let inputPrice = priceTextField.textToInt
        let memo = memoTextView.text ?? ""
        guard let price = inputPrice else {
            showAlert()
            return
        }
        let signPrice = priceSwicth.isOn ? price : -price

        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let  challengeDocID = challenge?.docID else { return }

        let saveMoneyReport = SaveMoneyReport(savingAmount: signPrice, memo: memo)

        challenge?.reports.append(saveMoneyReport)

        let challegenRef = Firestore.firestore().collection(CollectionName.users).document(uid).collection(CollectionName.challenges).document(challengeDocID)
        do {
            try challegenRef.setData(from: challenge)
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }

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
