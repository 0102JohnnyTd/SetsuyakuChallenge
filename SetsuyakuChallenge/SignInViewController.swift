//
//  SignInViewController.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/22.
//

import UIKit

final class SignInViewController: UIViewController {
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!

    private var textFields: [UITextField] { [emailTextField, passwordTextField] }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
