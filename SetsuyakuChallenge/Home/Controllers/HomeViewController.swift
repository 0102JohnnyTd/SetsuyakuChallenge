//
//  HomeViewController.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/14.
//

import UIKit

final class HomeViewController: UIViewController {
    @IBOutlet private weak var challengeCollectionView: UICollectionView!
    @IBOutlet private weak var showCreateChallengeVCButton: UIButton!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!

    // セグメントを切り替えたタイミングでcollectionViewを更新する
    @IBAction private func segment(_ sender: Any) {
        if segmentedControl.selectedSegmentIndex == 0 {
            showCreateChallengeVCButton.isHidden = false
            challengeCollectionView.reloadData()
        } else {
            showCreateChallengeVCButton.isHidden = true
            challengeCollectionView.reloadData()
        }
    }
    
    @IBAction private func didTapShowCreateChallengeVCButton(_ sender: Any) {
        showCreateChallengeVC()
    }

    // FirebaseFirestore(データの保存/取得など)を管理するモデルのインスタンスを生成して格納
    private let firebaseFirestoreManager = FirebaseFirestoreManager()
    // FirebaseAuthentication周り(アカウントの作成など)の処理を管理するモデルにインスタンスを生成して格納
    private let firebaseAuthManager = FirebaseAuthManager()

    // 現在取り組んでいるチャレンジを格納する配列
    private var challenges: [Challenge] = []
    // 目標を達成したチャレンジを格納する配列
    private var completedChallenges: [Challenge] = []
    // CollectionViewに表示させるデータを格納する配列
       // Segmentが0(チャレンジ中)なら配列challengesを返す 1(達成済み)ならcompletedChallengesを返す
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
        setUpSegmentedControl()
        setUpShowCreateChallengeButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firebaseAuthManager.checkIsLogout {
            showSignUpVC()
        }
        fetchChallengeData()
    }

    // Firestoreに保存されたチャレンジデータを取得
    private func fetchChallengeData() {
        challenges.removeAll()
        completedChallenges.removeAll()

        firebaseFirestoreManager.fetchChallengeData() { [self] result in
            switch result {
            case .success(let challenge):
                if let challenge = challenge {
                    if challenge.isChallenge {
                        challenges.append(challenge)
                    } else {
                        completedChallenges.append(challenge)
                    }
                }
                self.challengeCollectionView.reloadData()
                firebaseFirestoreManager.compareValue(challenges: challenges) { completedChallenge in
                    showTargetAchievementAlert(completedChallenge: completedChallenge.element, name: completedChallenge.element.name)
                }
            case .failure:
                // 後ほどエラー処理追加
                break
            }
        }
    }

    // SaveMoneyReportListViewControllerのchallengeプロパティにCollectionViewに表示しているデータを渡す
    private func passDataToSaveMoneyReportListVC(saveMoneyReportListVC: SaveMoneyReportListViewController, row: Int) {
        saveMoneyReportListVC.challenge = filteredChallenges[row]
    }

    // CreateChallengeViewControllerに遷移 ただし、challengesの要素が2つ以上あるとアラートを表示
    private func showCreateChallengeVC() {
        guard challenges.count < 2 else {
            showChallengesCountOverAlert()
            return
        }
        let createChallengeVC = UIStoryboard(name: CreateChallengeViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: CreateChallengeViewController.identifier) as! CreateChallengeViewController
        navigationController?.pushViewController(createChallengeVC, animated: true)
    }

    // SignUpViewControllerに遷移
    private func showSignUpVC() {
        let navController = UIStoryboard(name: SignUpViewController.storyboardName, bundle: nil).instantiateInitialViewController() as! UINavigationController
        navController.modalPresentationStyle = .fullScreen

        let signUpVC = navController.topViewController as! SignUpViewController
        signUpVC.presentationController?.delegate = self

        present(navController, animated: true)
    }

    // SaveMoneyReportListViewControllerに遷移
    private func showSaveMoneyReportListVC(row: Int) {
        let navController = UIStoryboard(name: SaveMoneyReportListViewController.storyboardName, bundle: nil).instantiateInitialViewController() as! UINavigationController
        let saveMoneyReportListVC = navController.topViewController as! SaveMoneyReportListViewController
        passDataToSaveMoneyReportListVC(saveMoneyReportListVC: saveMoneyReportListVC, row: row)
        navigationController?.pushViewController(saveMoneyReportListVC, animated: true)
    }

    // challengesの個数オーバーを伝えるアラートを表示
    private func showChallengesCountOverAlert() {
        let alertController = generateChallengesCountOverAlert()
        present(alertController, animated: true)
    }

    // チャレンジ達成を伝えるアラートを表示
    private func showTargetAchievementAlert(completedChallenge: Challenge, name: String) {
        let alertController = generateTargetAchievementAlert(completedChallenge: completedChallenge, name: name)
        present(alertController, animated: true)
    }

    // チャレンジ達成を伝えるアラートを生成
    private func generateTargetAchievementAlert(completedChallenge: Challenge, name: String) -> UIAlertController {
        let alertController = UIAlertController(title: AlertTitle.targetaAchievement, message: "目標『\(name)』" + AlertMessage.targetaAchievement, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: AlertAction.ok, style: .default) { [weak self] _ in
            self?.fetchChallengeData()
        })
        return alertController
    }

    // challengesの個数オーバーを伝えるアラートを生成
    private func generateChallengesCountOverAlert() -> UIAlertController {
        let alertController = UIAlertController(title: AlertTitle.countOverError, message: AlertMessage.countOverError, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: AlertAction.ok, style: .default))
        return alertController
    }

    // CollectionViewにCellを表示させるための処理
    private func setUpCollectionView() {
        challengeCollectionView.delegate = self
        challengeCollectionView.dataSource = self
        challengeCollectionView.register(ChallengeCollectionViewCell.nib, forCellWithReuseIdentifier: ChallengeCollectionViewCell.identifier)
        setUpCellLayout()
    }

    // SegmentedControlのアピアランスを調整
    private func setUpSegmentedControl() {
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        segmentedControl.selectedSegmentTintColor = .mainColor()
        segmentedControl.backgroundColor = .systemGray4
    }

    // 画面右下のボタンのアピアランスを調整
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

    // CollectionViewCellのアピアランスを調整
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

// dismissが実行された時に実行される処理
extension HomeViewController: UIAdaptivePresentationControllerDelegate {
    // サインイン完了時に以前サインインしていたアカウントの情報が残っていた場合は削除する
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        challenges.removeAll()
        completedChallenges.removeAll()
        challengeCollectionView.reloadData()
        fetchChallengeData()
    }
}
