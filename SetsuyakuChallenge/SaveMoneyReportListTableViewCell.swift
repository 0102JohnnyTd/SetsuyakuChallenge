//
//  SaveMoneyReportListTableViewCell.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/29.
//

import UIKit

class SaveMoneyReportListTableViewCell: UITableViewCell {
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var memoLabel: UILabel!
    
    static let nib = UINib(nibName: String(describing: SaveMoneyReportListTableViewCell.self), bundle: nil)
    static let identifier = String(describing: SaveMoneyReportListTableViewCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpBackgroundView()
    }

    private func configure(price: String, memo: String) {
        priceLabel.text = price
        memoLabel.text = memo
    }

    private func setUpBackgroundView() {
        self.backgroundView = UIView()
        backgroundView?.backgroundColor = .mainColor()
    }
}
