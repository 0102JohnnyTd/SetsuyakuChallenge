//
//  UserDetailsTableViewCell.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/12.
//

import UIKit

final class UserDetailsTableViewCell: UITableViewCell {
    @IBOutlet private weak var optionLabel: UILabel!

    func configure(option: String, textColor: UIColor) {
        optionLabel.text = option
        optionLabel.textColor = textColor
    }
}
