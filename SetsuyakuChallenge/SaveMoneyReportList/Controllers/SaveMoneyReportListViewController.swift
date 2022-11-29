//
//  SaveMoneyReportListViewController.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/29.
//

import UIKit
//import FirebaseAuth
//import FirebaseFirestore

final class SaveMoneyReportListViewController: UIViewController {
    @IBOutlet private weak var saveMoneyReportListTableView: UITableView!

    // ハードコーディング対策
    static let storyboardName = "SaveMoneyReportList"
    static let identifier = "SaveMoneyReportList"

    private let segueID = "ShowCreateReportVCSegue"

    // Firestoreから取得した値を保存するプロパティ
    var challenge: Challenge?

    private let firebaseFirestoreManager = FirebaseFirestoreManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firebaseFirestoreManager.fetchReportsData(challenge: challenge) { result in
            switch result {
            case .success(let challenge):
                if let challenge = challenge {
                    self.challenge?.reports = challenge.reports
                    self.saveMoneyReportListTableView.reloadData()
                }
            case .failure(_):
                break
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

    // Firestoreに保存されているChallengeのreportデータを取得
//    private func fetchReportsData() {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        guard let challengeDocID = challenge?.docID else { return }
//        let challengeRef = Firestore.firestore().collection(CollectionName.users).document(uid).collection(CollectionName.challenges).document(challengeDocID)
//
//        challengeRef.getDocument { snapshot, error in
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//            do {
//                let challenge = try snapshot?.data(as: Challenge.self)
//                if let challenge = challenge {
//                    self.challenge?.reports = challenge.reports
//                    self.saveMoneyReportListTableView.reloadData()
//                }
//            } catch {
//                print(error)
//            }
//        }
//    }

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
