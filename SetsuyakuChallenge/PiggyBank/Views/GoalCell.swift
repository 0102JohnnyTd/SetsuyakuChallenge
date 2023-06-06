//
//  GoalCell.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2023/06/05.
//

import UIKit

final class GoalCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var goalAmountLabel: UILabel!
    @IBOutlet private weak var percentageLabel: UILabel!
    @IBOutlet private weak var progressView: UIProgressView!

    /// Cellを表示させる画面で読み込みさせるNIBファイル
    static let nib = UINib(nibName: String(describing: GoalCell.self), bundle: nil)
    /// Cellを表示させる画面に渡すCellのID
    static let identifier = String(describing: GoalCell.self)

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
}

