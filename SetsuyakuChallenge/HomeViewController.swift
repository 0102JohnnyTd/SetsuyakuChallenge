//
//  HomeViewController.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/14.
//

import UIKit
import FirebaseAuth

final class HomeViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkIsLogin()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func checkIsLogin() {
        if Auth.auth().currentUser == nil {
            showSignUpVC()
        }
        print("現在ログイン状態です")
    }

    private func showSignUpVC() {
        print(#function)

        let signUpVC = UIStoryboard(name: SignUpViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: SignUpViewController.identifier) as! SignUpViewController
        let nav = UINavigationController(rootViewController: signUpVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
}
