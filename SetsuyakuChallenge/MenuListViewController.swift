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

private enum SupportSectionCell: Int, CaseIterable {
    case formCell
}

private enum GeneralSectionCell: Int, CaseIterable {
    case termsOfServiceCell
    case privacyPolicyCell
}

private enum URLManager {
    static let form = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSflWh3XRQS74ocT8WfpWCAMq1vlU35ZsPhdCLTmupQ5GyjAdA/viewform")!
    static let termsOfService = URL(string: "https://sites.google.com/view/uita-termsofservice/%E3%83%9B%E3%83%BC%E3%83%A0")
    static let privacyPolicy = URL(string: "https://sites.google.com/view/uita-privacypolicy/%E3%83%9B%E3%83%BC%E3%83%A0")
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

    private func setUpSection(section: Int) -> UIView {
        let headerView = generateHeaderView()
        let titleLabel = generateTitleLabel()
        setUpTitleLabelConstraint(title: titleLabel, headerView: headerView)
        titleLabel.text = MenuListTableViewCell.sectionNameArray[section]
        return headerView
    }

    private func generateHeaderView() -> UIView {
        let headerView = UIView()
        headerView.backgroundColor = .mainColor()
        return headerView
    }

    private func generateTitleLabel() -> UILabel {
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        return titleLabel
    }

    private func setUpTitleLabelConstraint(title: UILabel, headerView: UIView) {
        headerView.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        title.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16).isActive = true
    }
}

extension MenuListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        setUpSection(section: section)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionType = Section(rawValue: section)

        switch sectionType {
        case .supportSection: return SupportSectionCell.allCases.count
        case .generalSection: return GeneralSectionCell.allCases.count
        case .none: return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        menuListTableView.dequeueReusableCell(withIdentifier: MenuListTableViewCell.identifier, for: indexPath) as! MenuListTableViewCell
    }
}
