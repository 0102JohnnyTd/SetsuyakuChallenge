//
//  RewordQuestCell.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2023/06/07.
//

import UIKit

/// ごほうびクエストを表示するCell
final class RewardQuestCell: UICollectionViewCell {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var currentCountLabel: UILabel!
    @IBOutlet private weak var goalCountLabel: UILabel!
    @IBOutlet private weak var progressView: UIProgressView!

    /// Cellを表示させる画面で読み込みさせるNIBファイル
    static let nib = UINib(nibName: String(describing: RewardQuestCell.self), bundle: nil)
    /// Cellを表示させる画面に渡すCellのID
    static let identifier = String(describing: RewardQuestCell.self)

    /// Cellのレイアウトを実装
    func setUpCellLayout() {
        setUpBackgroundView()
        setUpContentView()
        configProgressView()
    }

    /// BackgroundViewを生成
    private func setUpBackgroundView() {
        self.backgroundView = UIView()
        self.backgroundView?.backgroundColor = .mainColor()
        self.backgroundView?.layer.cornerRadius = 10.0
    }

    /// ContentViewを生成
    private func setUpContentView() {
        self.contentView.layer.masksToBounds = true
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 2, height: 4)
        self.layer.shadowRadius = 10.0
        self.layer.shadowOpacity = 0.4
    }

    private func configProgressView() {
        progressView.progressTintColor = .subColor()
    }
}
