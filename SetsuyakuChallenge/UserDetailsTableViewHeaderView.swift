//
//  UserDetailsTableViewHeaderView.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/12.
//

import UIKit

final class UserDetailsTableViewHeaderView: UITableViewHeaderFooterView {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!

    static let nib = UINib(nibName: String(describing: UserDetailsTableViewHeaderView.self), bundle: nil)
    static let identifier = String(describing: UserDetailsTableViewHeaderView.self)
    
    func configure(name: String, email: String) {
        nameLabel.text = name
        emailLabel.text = email
    }
}
