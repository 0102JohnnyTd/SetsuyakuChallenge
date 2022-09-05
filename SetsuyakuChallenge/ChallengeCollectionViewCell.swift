//
//  ChallengeCollectionViewCell.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/17.
//

import UIKit

final class ChallengeCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var totalAmountLabel: UILabel!
    @IBOutlet private weak var goalAmountLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    
    static let nib = UINib(nibName: String(describing: ChallengeCollectionViewCell.self), bundle: nil)
    static let identifier = String(describing: ChallengeCollectionViewCell.self)

    private let priceManager = PriceManager.shared

    override func awakeFromNib() {
        priceManager.delegate = self
        totalAmountLabel.text = String(priceManager.totalPrice)
    }

    private func upDateTotalPriceLabel(price: Int) {
        totalAmountLabel.text = String(price)
    }

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
    
    func configure(itemName: String, goalPrice: String, itemImage: UIImage) {
        setUpCellLayout()
        nameLabel.text = itemName
        goalAmountLabel.text = "/ " + goalPrice + "円"
        imageView.image = itemImage
    }
}

extension ChallengeCollectionViewCell: PriceManagerDelegate {
    func didChangePrice(price: Int) {
        upDateTotalPriceLabel(price: price)
    }
}
