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
    }

    private func setUpButton() {
        createReportButton.mainButton()
    }
}
