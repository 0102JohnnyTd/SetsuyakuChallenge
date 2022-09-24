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

    @IBOutlet private weak var showCreateChallengeVCButton: UIButton!

    @IBOutlet private weak var segmentedControl: UISegmentedControl!

    @IBAction private func segment(_ sender: Any) {
        if segmentedControl.selectedSegmentIndex == 0 {
            challengeCollectionView.reloadData()
        } else {
            challengeCollectionView.reloadData()
        }
    }

    private var challenges: [Challenge] = []
    private var completedChallenges: [Challenge] = []
    private var filteredChallenges: [Challenge] {
        if segmentedControl.selectedSegmentIndex == 0 {
            return challenges
        } else {
            return completedChallenges
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        setUpShowCreateChallengeButton()
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

    private func compareValue() {
        challenges.enumerated().forEach {
            if $0.element.totalSavingAmount >= $0.element.goalAmount {
                // Firestoreで保存した値をHomeで表示させるのでこのtoggleはなくても良い気がするのだが、万が一にも保存が失敗した時のことを考えると不安なので一応残しておく。
                let index = $0.offset
                challenges[index].isChallenge.toggle()
                updateDataForFireStore(challenge: $0.element)
                showTargetAchievementAlert(completedChallenge: $0.element, name: $0.element.name)
            }
            print("どの値も目標達成してないぜ")
        }
    }

    private func fetchChallengeData() {
        challenges.removeAll()
        completedChallenges.removeAll()

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
                        if challenge.isChallenge {
                            self.challenges.append(challenge)
                        } else {
                            self.completedChallenges.append(challenge)
                        }
                        self.challengeCollectionView.reloadData()
                        self.compareValue()
                    }
                } catch {
                    print(error)
                }
            }
        }
    }

    private func updateDataForFireStore(challenge: Challenge) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let challengeID = challenge.docID else { return }
        let challengeRef = Firestore.firestore().collection(CollectionName.users).document(uid).collection(CollectionName.challenges).document(challengeID)

        challengeRef.updateData([FieldValue.isChallenge: false]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }

    private func passDataToSaveMoneyReportListVC(saveMoneyReportListVC: SaveMoneyReportListViewController, row: Int) {
        saveMoneyReportListVC.challenge = filteredChallenges[row]
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

    private func showTargetAchievementAlert(completedChallenge: Challenge, name: String) {
        let alertController = generateTargetAchievementAlert(completedChallenge: completedChallenge, name: name)
        present(alertController, animated: true)
    }

    private func generateTargetAchievementAlert(completedChallenge: Challenge, name: String) -> UIAlertController {
        let alertController = UIAlertController(title: AlertTitle.targetaAchievement, message: "目標『\(name)』" + AlertMessage.targetaAchievement, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: AlertAction.ok, style: .default) { [weak self] _ in
            self?.completedChallenges.append(completedChallenge)
            self?.challenges.removeAll { $0.isChallenge == false }
            self?.challengeCollectionView.reloadData()
        })
        return alertController
    }

    private func setUpCollectionView() {
        challengeCollectionView.delegate = self
        challengeCollectionView.dataSource = self
        challengeCollectionView.register(ChallengeCollectionViewCell.nib, forCellWithReuseIdentifier: ChallengeCollectionViewCell.identifier)
        setUpCellLayout()
    }

    private func setUpShowCreateChallengeButton() {
        let width = UIScreen.main.bounds.width / 5
        setUpButtonSize(width: width)
        setUpButtonAppearance(width: width)
    }

    private func setUpButtonSize(width: CGFloat) {
        showCreateChallengeVCButton.widthAnchor.constraint(equalToConstant: width).isActive = true
        showCreateChallengeVCButton.heightAnchor.constraint(equalToConstant: width).isActive = true
    }

    private func setUpButtonAppearance(width: CGFloat) {
        showCreateChallengeVCButton.backgroundColor = .subColor()
        showCreateChallengeVCButton.layer.masksToBounds = false
        showCreateChallengeVCButton.layer.cornerRadius = width / 2
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
        filteredChallenges.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = challengeCollectionView.dequeueReusableCell(withReuseIdentifier: ChallengeCollectionViewCell.identifier, for: indexPath) as! ChallengeCollectionViewCell

        cell.configure(name: filteredChallenges[indexPath.row].name, goalAmount: filteredChallenges[indexPath.row].goalAmount, imageURL: filteredChallenges[indexPath.row].imageURL, totalSavingAmount: filteredChallenges[indexPath.row].totalSavingAmount)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showSaveMoneyReportListVC(row: indexPath.row)
    }
}

extension HomeViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        challenges.removeAll()
        completedChallenges.removeAll()
        challengeCollectionView.reloadData()
        fetchChallengeData()
    }
}
