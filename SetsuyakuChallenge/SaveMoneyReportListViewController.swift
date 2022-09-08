//
//  SaveMoneyReportListViewController.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/29.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

final class SaveMoneyReportListViewController: UIViewController {
    @IBOutlet private weak var saveMoneyReportListTableView: UITableView!

    static let storyboardName = "SaveMoneyReportList"
    static let identifier = "SaveMoneyReportList"

    private let segueID = "ShowCreateReportVCSegue"

    var challenge: Challenge?
    private var saveMoneyReports: [SaveMoneyReport] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        fetchSaveMoneyReportData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueID {
            let createSaveMoneyReportVC = segue.destination as! CreateSaveMoneyReportViewController
            createSaveMoneyReportVC.challenge = challenge
        }
    }

    private func fetchSaveMoneyReportData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let challengeDocID = challenge?.docID else { return }

        let saveMoneyReportRef = Firestore.firestore().collection(CollectionName.users).document(uid).collection(CollectionName.challenges).document(challengeDocID).collection(CollectionName.reports)

        saveMoneyReportRef.addSnapshotListener { snapshots, err  in
            if let err = err {
                print("saveMoneyReportデータの取得に失敗しました: \(err)")
            }
            print("saveMoneyReportデータの取得に成功しました")
            snapshots?.documentChanges.forEach {
                switch $0.type {
                case .added:
                    let dic = $0.document.data()
                    let saveMoneyReport = SaveMoneyReport.init(dic: dic)

                    self.saveMoneyReports.append(saveMoneyReport)
                    self.saveMoneyReportListTableView.reloadData()
                case .modified, .removed:
                    break
                }
            }
        }
    }

    private func setUpTableView() {
        saveMoneyReportListTableView.delegate = self
        saveMoneyReportListTableView.dataSource = self
        registerTableViewCell()
    }

    private func registerTableViewCell() {
        saveMoneyReportListTableView.register(SaveMoneyReportListTableViewCell.nib, forCellReuseIdentifier: SaveMoneyReportListTableViewCell.identifier)
    }
}

extension SaveMoneyReportListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        saveMoneyReports.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = saveMoneyReportListTableView.dequeueReusableCell(withIdentifier: SaveMoneyReportListTableViewCell.identifier, for: indexPath) as! SaveMoneyReportListTableViewCell

        cell.configure(savingAmount: saveMoneyReports[indexPath.row].savingAmount, memo: saveMoneyReports[indexPath.row].memo)

        return cell
    }
}
