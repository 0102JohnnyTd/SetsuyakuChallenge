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
    private var challenges: [Challenge] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchChallengeData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueID {
            let createSaveMoneyReportVC = segue.destination as! CreateSaveMoneyReportViewController
            createSaveMoneyReportVC.challenge = challenge
        }
    }

    private func fetchChallengeData() {
        challenges.removeAll()

        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let challengeDocID = challenge?.docID else { return }
        let challengeRef = Firestore.firestore().collection(CollectionName.users).document(uid).collection(CollectionName.challenges).document(challengeDocID)

        print("challengesをremoveAllした： \(self.challenges)")
        challengeRef.getDocument { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            do {
                let challenge = try snapshot?.data(as: Challenge.self)
                if let challenge = challenge {
                    self.challenge?.reports = challenge.reports
                    self.saveMoneyReportListTableView.reloadData()
                }
            } catch {
                print(error)
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
        challenge?.reports.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = saveMoneyReportListTableView.dequeueReusableCell(withIdentifier: SaveMoneyReportListTableViewCell.identifier, for: indexPath) as! SaveMoneyReportListTableViewCell
        
        cell.configure(savingAmount: challenge?.reports[indexPath.row].savingAmount ?? 0, memo: challenge?.reports[indexPath.row].memo ?? "")

        return cell
    }
}
