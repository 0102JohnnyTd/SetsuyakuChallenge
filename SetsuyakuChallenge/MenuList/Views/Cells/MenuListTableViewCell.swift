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

    // ハードコーディング対策
    static let nib = UINib(nibName: String(describing: MenuListTableViewCell.self), bundle: nil)
    static let identifier = String(describing: MenuListTableViewCell.self)

    // セクション名,セル名をまとめた配列
    static let sectionNameArray = ["サポート", "一般"]
    static let supportSectionCellName = ["お問い合わせ"]
    static let generalSectionCellName = ["利用規約", "プライバシーポリシー", "アプリのバージョン"]

    func configure(cellNameArray: [String], row: Int) {
        titleLabel.text = cellNameArray[row]
    }

    func setUpVersion() {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String

        detailLabel.text = "\(version) (\(build))"
    }
}
