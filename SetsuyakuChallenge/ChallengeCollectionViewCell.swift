//
//  ChallengeCollectionViewCell.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/17.
//

import UIKit

final class ChallengeCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var itemNameLabel: UILabel!
    @IBOutlet private weak var totalPriceLabel: UILabel!
    @IBOutlet private weak var goalPriceLabel: UILabel!
    @IBOutlet private weak var itemImageView: UIImageView!
    
    static let nib = UINib(nibName: String(describing: ChallengeCollectionViewCell.self), bundle: nil)
    static let identifier = String(describing: ChallengeCollectionViewCell.self)

    private func setUpCellLayout() {
        setUpBackgroundView()
        setUpContentView()
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
    
    func configure() {
        setUpCellLayout()
    }
}
