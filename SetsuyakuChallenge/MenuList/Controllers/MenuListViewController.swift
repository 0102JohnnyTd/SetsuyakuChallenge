//
//  MenuListViewController.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/09/22.
//

import UIKit
import SafariServices

// セクションを列挙したenum
private enum Section: Int, CaseIterable {
    case supportSection
    case generalSection
}

//　SupportSectionに表示するCellを列挙したenum
private enum SupportSectionCell: Int, CaseIterable {
    case formCell
}

//　GeneralSectionに表示するCellを列挙したenum
private enum GeneralSectionCell: Int, CaseIterable {
    case termsOfServiceCell
    case privacyPolicyCell
    case appVersionCell
}

// URLを管理するenum
private enum URLManager {
    // ❓サーバーの不具合が起きた時、強制アンラップをしているが故にクラッシュなどが起きないかテストする必要あり
    static let form = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSflWh3XRQS74ocT8WfpWCAMq1vlU35ZsPhdCLTmupQ5GyjAdA/viewform")!
    static let termsOfService = URL(string: "https://sites.google.com/view/uita-termsofservice/%E3%83%9B%E3%83%BC%E3%83%A0")!
    static let privacyPolicy = URL(string: "https://sites.google.com/view/uita-privacypolicy/%E3%83%9B%E3%83%BC%E3%83%A0")!
}

final class MenuListViewController: UIViewController {
    @IBOutlet private weak var menuListTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }

    // SafariViewControllerを表示
    private func showSafariVC(url: URL) {
        let safariVC = generateSafariVC(url: url)
        present(safariVC, animated: true)
    }

    // SafariViewControllerを生成
    private func generateSafariVC(url: URL) -> SFSafariViewController {
        let safariVC = SFSafariViewController(url: url)
        return safariVC
    }

    // セクションを生成
    private func generateHeaderView() -> UIView {
        let headerView = UIView()
        headerView.backgroundColor = .mainColor()
        return headerView
    }

    // セクションのTitleを表示するUILabelを生成
    private func generateTitleLabel() -> UILabel {
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        return titleLabel
    }

    // TableViewにセクション、セルを表示するための処理
    private func setUpTableView() {
        menuListTableView.delegate = self
        menuListTableView.dataSource = self
        menuListTableView.register(MenuListTableViewCell.nib, forCellReuseIdentifier: MenuListTableViewCell.identifier)
    }

    // セクションのアピアランスを設定
    private func setUpSection(section: Int) -> UIView {
        let headerView = generateHeaderView()
        let titleLabel = generateTitleLabel()
        setUpTitleLabelConstraint(title: titleLabel, headerView: headerView)
        titleLabel.text = MenuListTableViewCell.sectionNameArray[section]
        return headerView
    }

    // セクションのTitleに制約を追加
    private func setUpTitleLabelConstraint(title: UILabel, headerView: UIView) {
        headerView.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        title.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16).isActive = true
    }
}

extension MenuListViewController: UITableViewDelegate, UITableViewDataSource {
    // enum Sectionのcaseの数だけセクションを生成する
    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        setUpSection(section: section)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // セクションごとに表示するCellの数を切り分ける
        let sectionType = Section(rawValue: section)

        switch sectionType {
        case .supportSection: return SupportSectionCell.allCases.count
        case .generalSection: return GeneralSectionCell.allCases.count
        case .none: return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = menuListTableView.dequeueReusableCell(withIdentifier: MenuListTableViewCell.identifier, for: indexPath) as! MenuListTableViewCell

        // セクションごとにセルに表示するコンテンツを切り分ける
        let sectionType = Section(rawValue: indexPath.section)
        switch sectionType {
        case .supportSection:
            cell.configure(cellNameArray: MenuListTableViewCell.supportSectionCellName, row: indexPath.row)
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        case .generalSection:
            if indexPath.row == GeneralSectionCell.appVersionCell.rawValue {
                cell.configure(cellNameArray: MenuListTableViewCell.generalSectionCellName, row: indexPath.row )
                cell.setUpVersion()
            } else {
                cell.configure(cellNameArray: MenuListTableViewCell.generalSectionCellName, row: indexPath.row)
                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            }
        case .none: break
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let sectionType = Section(rawValue: indexPath.section)

        // セクションごとに表示するセルを切り分けた上で、セルごとにタップ時に実行する処理を切り分ける
        switch sectionType {
        case .supportSection: let supportSectionCell = SupportSectionCell(rawValue: indexPath.row)
            switch supportSectionCell {
            case .formCell: showSafariVC(url: URLManager.form)
            case .none: break
            }
        case .generalSection: let generalSectionCell = GeneralSectionCell(rawValue: indexPath.row)
            switch generalSectionCell {
            case .termsOfServiceCell: showSafariVC(url: URLManager.termsOfService)
            case .privacyPolicyCell: showSafariVC(url: URLManager.privacyPolicy)
            case .appVersionCell: break
            case .none: break
            }
        case .none: break
        }
    }
}
