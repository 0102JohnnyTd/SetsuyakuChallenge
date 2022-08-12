//
//  UserDetailsViewController.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/12.
//

import UIKit

final class UserDetailsViewController: UIViewController {
    @IBOutlet private weak var userDetailsTableView: UITableView!

    private let options = [Option(item: "ログアウト", textColorType: .normal), Option(item: "アカウントを削除する", textColorType: .warning)]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
