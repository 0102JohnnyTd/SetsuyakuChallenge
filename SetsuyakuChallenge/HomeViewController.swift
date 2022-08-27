//
//  HomeViewController.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/14.
//

import UIKit
import FirebaseAuth

final class HomeViewController: UIViewController {
    @IBOutlet private weak var challengeCollectionView: UICollectionView!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkIsLogin()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
    }

    private func checkIsLogin() {
        if Auth.auth().currentUser == nil {
            showSignUpVC()
        }
        print("現在ログイン状態です")
    }

    private func showSignUpVC() {
        print(#function)

        let signUpVC = UIStoryboard(name: SignUpViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: SignUpViewController.identifier) as! SignUpViewController
        let nav = UINavigationController(rootViewController: signUpVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }

    private func setUpCollectionView() {
        challengeCollectionView.delegate = self
        challengeCollectionView.dataSource = self
        challengeCollectionView.register(ChallengeCollectionViewCell.nib, forCellWithReuseIdentifier: ChallengeCollectionViewCell.identifier)
        setUpCellLayout()
    }

    private func setUpCellLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 30
        layout.itemSize = setUpCellSize()
        challengeCollectionView.collectionViewLayout = layout
    }

    private func setUpCellSize() -> CGSize {
        let width = UIScreen.main.bounds.width - 48
        let height = width * 0.5
        return CGSize(width: width, height: height)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Challenge.array.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = challengeCollectionView.dequeueReusableCell(withReuseIdentifier: ChallengeCollectionViewCell.identifier, for: indexPath) as! ChallengeCollectionViewCell
        cell.configure(itemName: "お菓子", goalPrice: String(100), itemImage: UIImage(named: "Default Item Image")!)

        return cell
    }
}
