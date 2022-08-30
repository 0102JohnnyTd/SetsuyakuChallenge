//
//  SaveMoneyReportListTableViewCell.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/29.
//

import UIKit

class SaveMoneyReportListTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpBackgroundView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func setUpBackgroundView() {
        self.backgroundView = UIView()
        backgroundView?.backgroundColor = .mainColor()
    }
}
