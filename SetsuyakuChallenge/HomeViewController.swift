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
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        challengeCollectionView.dequeueReusableCell(withReuseIdentifier: ChallengeCollectionViewCell.identifier, for: indexPath) as! ChallengeCollectionViewCell
    }
}
