//
//  ChallengeCollectionViewCell.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/17.
//

import UIKit

final class ChallengeCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var totalLabel: UILabel!
    @IBOutlet private weak var goalLabel: UILabel!

    static let nib = UINib(nibName: String(describing: ChallengeCollectionViewCell.self), bundle: nil)
    static let identifier = String(describing: ChallengeCollectionViewCell.self)
}
