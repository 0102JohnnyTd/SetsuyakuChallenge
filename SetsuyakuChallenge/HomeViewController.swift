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

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkIsLogin()
        fetchChallengeData()
    }

    private func checkIsLogin() {
        if Auth.auth().currentUser == nil {
            showSignUpVC()
        } else {
            print(Auth.auth().currentUser)
            print("現在ログイン状態です")
        }
    }

    private func fetchChallengeData() {
        challenges.removeAll()

        guard let uid = Auth.auth().currentUser?.uid else { return }
        let challengeRef = Firestore.firestore().collection(CollectionName.users).document(uid).collection(CollectionName.challenges)

        challengeRef.getDocuments { snapshots, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            snapshots?.documents.forEach { snapshot in
                do {
                    var challenge = try snapshot.data(as: Challenge.self)
                    challenge?.docID = snapshot.documentID
                    challenge?.totalSavingAmount = 0
                    challenge?.reports.forEach {
                        challenge?.totalSavingAmount += $0.savingAmount
                    }
                    if let challenge = challenge {
                        self.challenges.append(challenge)
                        self.challengeCollectionView.reloadData()
                    }
                } catch {
                    print(error)
                }
            }
        }
    }

    private func passDataToSaveMoneyReportListVC(saveMoneyReportListVC: SaveMoneyReportListViewController, row: Int) {
        saveMoneyReportListVC.challenge = challenges[row]
    }

    private func showSignUpVC() {
        let navController = UIStoryboard(name: SignUpViewController.storyboardName, bundle: nil).instantiateInitialViewController() as! UINavigationController
        navController.modalPresentationStyle = .fullScreen

        let signUpVC = navController.topViewController as! SignUpViewController
        signUpVC.presentationController?.delegate = self

        present(navController, animated: true)
    }

    private func showSaveMoneyReportListVC(row: Int) {
        let navController = UIStoryboard(name: SaveMoneyReportListViewController.storyboardName, bundle: nil).instantiateInitialViewController() as! UINavigationController
        let saveMoneyReportListVC = navController.topViewController as! SaveMoneyReportListViewController
        passDataToSaveMoneyReportListVC(saveMoneyReportListVC: saveMoneyReportListVC, row: row)
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

        cell.configure(name: challenges[indexPath.row].name, goalAmount: challenges[indexPath.row].goalAmount, imageURL: challenges[indexPath.row].imageURL, totalSavingAmount: challenges[indexPath.row].totalSavingAmount)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showSaveMoneyReportListVC(row: indexPath.row)
    }
}

extension HomeViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        challenges.removeAll()
        challengeCollectionView.reloadData()
        fetchChallengeData()
    }
}
