//
//  ChallengeCollectionViewCell.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/17.
//

import UIKit
import Kingfisher

final class ChallengeCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var totalAmountLabel: UILabel!
    @IBOutlet private weak var goalAmountLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var progressView: UIProgressView!

    static let nib = UINib(nibName: String(describing: ChallengeCollectionViewCell.self), bundle: nil)
    static let identifier = String(describing: ChallengeCollectionViewCell.self)

    private func upDateTotalPriceLabel(price: Int) {
        totalAmountLabel.text = String(price)
    }

    private func setUpCellLayout() {
        setUpBackgroundView()
        setUpContentView()
        setUpProgressView()
    }
    private func setUpBackgroundView() {
        self.backgroundView = UIView()
        self.backgroundView?.backgroundColor = .mainColor()
        self.backgroundView?.layer.cornerRadius = 10.0
    }
    private func setUpContentView() {
        self.contentView.layer.masksToBounds = true
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 2, height: 4)
        self.layer.shadowRadius = 10.0
        self.layer.shadowOpacity = 0.4
    }

    private func setUpProgressView() {
        progressView.progressTintColor = .subColor()
    }
    
    func configure(name: String, goalAmount: Int, imageURL: String, totalSavingAmount: Int) {
        setUpCellLayout()
        nameLabel.text = name
        goalAmountLabel.text = "/ " + String(goalAmount) + "円"
        imageView.kf.setImage(with: URL(string: imageURL))
        totalAmountLabel.text = String(totalSavingAmount)
        progressView.progress = Float(totalSavingAmount) / Float(goalAmount)
    }
}
