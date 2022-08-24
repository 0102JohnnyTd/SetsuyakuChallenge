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

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButtonContents()
    }
    private func setUpButtonContents() {
        createChallengeButton.backgroundColor = .mainColor()
        createChallengeButton.layer.cornerRadius = 5
    }
}
