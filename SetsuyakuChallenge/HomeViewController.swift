//
//  HomeViewController.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/14.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

final class HomeViewController: UIViewController {
    @IBOutlet private weak var challengeCollectionView: UICollectionView!

    private var challenges: [Challenge] = []

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkIsLogin()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        fetchChallengeData()
    }

    private func checkIsLogin() {
        if Auth.auth().currentUser == nil {
            showSignUpVC()
        }
        print("現在ログイン状態です")
    }

    private func fetchChallengeData() {
        Firestore.firestore().collection(CollectionName.challenges).addSnapshotListener { (snapshots, err) in
            if let err = err {
                print("データの取得に失敗しました: \(err)")
            }
            snapshots?.documentChanges.forEach {
                switch $0.type {
                case .added:
                    let dic = $0.document.data()
                    var challenge = Challenge.init(dic: dic)
                    challenge.docID = $0.document.documentID

                    self.challenges.append(challenge)
                    self.challengeCollectionView.reloadData()
                case .modified, .removed:
                    break
                }
            }
        }
    }

    private func showSignUpVC() {
        print(#function)

        let signUpVC = UIStoryboard(name: SignUpViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: SignUpViewController.identifier) as! SignUpViewController
        let nav = UINavigationController(rootViewController: signUpVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }

    private func showSaveMoneyReportListVC() {
        let navController = UIStoryboard(name: SaveMoneyReportListViewController.storyboardName, bundle: nil).instantiateInitialViewController() as! UINavigationController
        let saveMoneyReportListVC = navController.topViewController as! SaveMoneyReportListViewController
        navigationController?.pushViewController(saveMoneyReportListVC, animated: true)
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
        let width = UIScreen.main.bounds.width - 32
        let height = width * 0.5
        return CGSize(width: width, height: height)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        challenges.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = challengeCollectionView.dequeueReusableCell(withReuseIdentifier: ChallengeCollectionViewCell.identifier, for: indexPath) as! ChallengeCollectionViewCell

        cell.configure(name: challenges[indexPath.row].name, goalAmount: challenges[indexPath.row].goalAmount, imageURL: challenges[indexPath.row].imageURL)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showSaveMoneyReportListVC()
    }
}
