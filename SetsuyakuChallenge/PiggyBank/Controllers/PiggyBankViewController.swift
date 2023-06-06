//
//  PiggyBankViewController.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2023/06/06.
//

import UIKit

final class PiggyBankViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        setUpCellLayout()
    }

    ///  CollectionViewにCellを表示させるための処理
    private func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GoalCell.nib, forCellWithReuseIdentifier: GoalCell.identifier)
        setUpCellLayout()
    }

    /// CollectionViewCellのアピアランスを調整
    private func setUpCellLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 30
        layout.itemSize = setUpCellSize()
        collectionView.collectionViewLayout = layout
    }
    /// Cellのサイズを設定
    private func setUpCellSize() -> CGSize {
        let width = UIScreen.main.bounds.width - 32
        let height = width * 0.5
        return CGSize(width: width, height: height)
    }
}

extension PiggyBankViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoalCell.identifier, for: indexPath) as! GoalCell
        cell.setUpCellLayout()
        return cell
    }
}
