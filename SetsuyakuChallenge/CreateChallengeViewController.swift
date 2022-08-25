//
//  CreateChallengeViewController.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/24.
//

import UIKit

final class CreateChallengeViewController: UIViewController {
    @IBOutlet private weak var itemImage: UIImageView!
    @IBOutlet private weak var itemTextField: UITextField!
    @IBOutlet private weak var priceTextField: UITextField!
    @IBOutlet private weak var createChallengeButton: UIButton!

    @IBAction private func didTapButton(_ sender: Any) {
    }

    private var textFields: [UITextField] { [itemTextField, priceTextField] }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButtonContents()
        setUpTextFiled()
    }
    private func setUpButtonContents() {
        createChallengeButton.backgroundColor = .mainColor()
        createChallengeButton.layer.cornerRadius = 5
    }
    private func setUpTextFiled() {
        textFields.forEach { $0.delegate = self }
        setUpNumberPad()
    }
    private func setUpNumberPad() {
        priceTextField.keyboardType = .numberPad
    }
}

extension CreateChallengeViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let textsIsEmpty = textFields.map { $0.text?.isEmpty ?? true }

        if textsIsEmpty[0] || textsIsEmpty[1] {
            createChallengeButton.isEnabled = false
        } else {
            createChallengeButton.isEnabled = true
        }
    }
}
