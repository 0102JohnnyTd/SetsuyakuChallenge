//
//  SaveMoneyReportListViewController.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/29.
//

import UIKit

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
    }

    override func viewDidAppear(_ animated: Bool) {
        saveMoneyReportListTableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueID {
            let createSaveMoneyReportVC = segue.destination as! CreateSaveMoneyReportViewController
            createSaveMoneyReportVC.challenge = challenge
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
        SaveMoneyReport.array.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = saveMoneyReportListTableView.dequeueReusableCell(withIdentifier: SaveMoneyReportListTableViewCell.identifier, for: indexPath) as! SaveMoneyReportListTableViewCell

//        cell.configure(price: String(SaveMoneyReport.array[indexPath.row].price), memo: SaveMoneyReport.array[indexPath.row].memo)

        return cell
    }
}
