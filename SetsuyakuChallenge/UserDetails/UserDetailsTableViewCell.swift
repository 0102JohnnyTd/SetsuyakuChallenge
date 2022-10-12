//
//  UserDetailsTableViewCell.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/12.
//

import UIKit

final class UserDetailsTableViewCell: UITableViewCell {
    @IBOutlet private weak var optionLabel: UILabel!

    static let nib = UINib(nibName: String(describing: UserDetailsTableViewCell.self), bundle: nil)
    static let identifier = String(describing: UserDetailsTableViewCell.self)

    func configure(option: String, textColor: UIColor) {
        optionLabel.text = option
        optionLabel.textColor = textColor
    }
}
