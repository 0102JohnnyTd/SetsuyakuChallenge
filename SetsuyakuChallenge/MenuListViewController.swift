//
//  MenuListViewController.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/09/22.
//

import UIKit

private enum Section: Int, CaseIterable {
    case supportSection
    case generalSection
}

final class MenuListViewController: UIViewController {
    @IBOutlet private weak var menuListTableView: UITableView!

    private let sampleArray = ["A", "B", "C"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }

    private func setUpTableView() {
        menuListTableView.delegate = self
        menuListTableView.dataSource = self
        menuListTableView.register(MenuListTableViewCell.nib, forCellReuseIdentifier: MenuListTableViewCell.identifier)
    }
}

extension MenuListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sampleArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        menuListTableView.dequeueReusableCell(withIdentifier: MenuListTableViewCell.identifier, for: indexPath) as! MenuListTableViewCell
    }
}
