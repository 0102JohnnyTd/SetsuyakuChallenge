//
//  SaveMoneyReportListViewController.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/29.
//

import UIKit

final class SaveMoneyReportListViewController: UIViewController {
    @IBOutlet private weak var saveMoneyReportListTableView: UITableView!

    // ハードコーディング対策
    static let storyboardName = "SaveMoneyReportList"
    static let identifier = "SaveMoneyReportList"

    private let segueID = "ShowCreateReportVCSegue"

    // Firestoreから取得した値を保存するプロパティ
    var challenge: Challenge?

    // FirebaseFirestore(データの保存/取得など)を管理するモデルのインスタンスを生成して格納
    private let firebaseFirestoreManager = FirebaseFirestoreManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firebaseFirestoreManager.fetchReportsData(challenge: challenge) { [ weak self ] result in
            switch result {
            case .success(let challenge):
                if let challenge = challenge {
                    self?.challenge?.reports = challenge.reports
                    self?.saveMoneyReportListTableView.reloadData()
                }
            case .failure(let error):
                guard let errorMessage = self?.firebaseFirestoreManager.getFirestoreErrorMessage(error: error) else { return }
                self?.showFetchDataErrorAlert(errorMessage: errorMessage)
            }
        }
    }

    // CreateSaveMoneyReportViewControllerに遷移時、challengeプロパティの値を渡す
       // 📖reportを保存する際、challengesコレクションのどのchallengeにreportを保存するかを識別させる為
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueID {
            let createSaveMoneyReportVC = segue.destination as! CreateSaveMoneyReportViewController
            createSaveMoneyReportVC.challenge = challenge
        }
    }
    
    // TableViewにセルを表示する為の処理
    private func setUpTableView() {
        saveMoneyReportListTableView.delegate = self
        saveMoneyReportListTableView.dataSource = self
        registerTableViewCell()
    }
    // XIBファイルのセルをViewControllerに登録
    private func registerTableViewCell() {
        saveMoneyReportListTableView.register(SaveMoneyReportListTableViewCell.nib, forCellReuseIdentifier: SaveMoneyReportListTableViewCell.identifier)
    }

    // データの取得失敗を伝えるアラートを表示
    private func showFetchDataErrorAlert(errorMessage: String) {
        let alertController = UIAlertController(title: AlertTitle.fetchDataError, message: errorMessage, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: AlertAction.retry, style: .default, handler: { [weak self] _ in
            guard let challenge = self?.challenge else { return }
            self?.firebaseFirestoreManager.fetchReportsData(challenge: challenge) { result in
                switch result {
                case .success(let challenge):
                    if let challenge = challenge {
                        self?.challenge?.reports = challenge.reports
                        self?.saveMoneyReportListTableView.reloadData()
                    }
                case .failure(let error):
                    guard let errorMessage = self?.firebaseFirestoreManager.getFirestoreErrorMessage(error: error) else { return }
                    self?.showFetchDataErrorAlert(errorMessage: errorMessage)
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: AlertAction.cancel, style: .cancel))

        present(alertController, animated: true)
    }
}

extension SaveMoneyReportListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        challenge?.reports.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = saveMoneyReportListTableView.dequeueReusableCell(withIdentifier: SaveMoneyReportListTableViewCell.identifier, for: indexPath) as! SaveMoneyReportListTableViewCell
        
        cell.configure(savingAmount: challenge?.reports[indexPath.row].savingAmount ?? 0, memo: challenge?.reports[indexPath.row].memo ?? "")

        return cell
    }
}
