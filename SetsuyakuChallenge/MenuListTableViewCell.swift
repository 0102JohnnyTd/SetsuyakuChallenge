//
//  MenuListTableViewCell.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/09/22.
//

import UIKit

final class MenuListTableViewCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!

    static let nib = UINib(nibName: String(describing: MenuListTableViewCell.self), bundle: nil)
    static let identifier = String(describing: MenuListTableViewCell.self)

    static let sectionNameArray = ["サポート", "一般"]
    static let supportSectionCellName = ["お問い合わせ"]
    static let generalSectionCellName = ["アプリのバージョン", "利用規約", "プライバシーポリシー"]

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
