//
//  UserDetailsViewController.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/12.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

private enum Cell: Int,CaseIterable {
    case logoutCell
    case deleteAccountCell
}

final class UserDetailsViewController: UIViewController {
    @IBOutlet private weak var userDetailsTableView: UITableView!

    private let options = [Option(item: "ログアウト", textColorType: .normal), Option(item: "アカウントを削除する", textColorType: .warning)]

    private var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }

    private func setUpTableView() {
        userDetailsTableView.delegate = self
        userDetailsTableView.dataSource = self
        userDetailsTableView.register(UserDetailsTableViewCell.nib, forCellReuseIdentifier: UserDetailsTableViewCell.identifier)
        userDetailsTableView.register(UserDetailsTableViewHeaderView.nib, forHeaderFooterViewReuseIdentifier: UserDetailsTableViewHeaderView.identifier)
    }

    private func getData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print("ユーザー情報の取得に失敗しました: \(err)")
            }
            print("ユーザー情報の取得に成功しました")
            let data = snapshot?.data()
            self.user  = User.init(dic: data!)
            self.userDetailsTableView.reloadData()
        }
    }

    private func showLogoutAlert() {
        let logoutAlert = UIAlertController(title: "ログアウト", message: "ログアウトしますか？", preferredStyle: .alert)
        logoutAlert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        logoutAlert.addAction(UIAlertAction(title: "ログアウト", style: .destructive, handler: { [self] _ in
            logout()
        }))
        present(logoutAlert, animated: true)
    }

    private func logout() {
        do {
            try Auth.auth().signOut()
            showDidFinishLogoutAlert()
        } catch {
            print(error)
        }
    }

    private func showDidFinishLogoutAlert() {
        let didFinishLououtAlert = UIAlertController(title: "ログアウト完了", message: "またのご利用待ってるぜ！", preferredStyle: .alert)

        didFinishLououtAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [self] _ in            navigationController?.popViewController(animated: true)
        }))
        present(didFinishLououtAlert, animated: true)
    }

    private func showDeleteAuthAlert() {
        let alert = UIAlertController(title: "アカウントを削除しますか？", message: "この操作は取り消せません", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        alert.addAction(UIAlertAction(title: "削除", style: .destructive, handler: { [weak self] _ in
            self?.deleteAccountData()
            self?.deleteAccount()
        }))
        present(alert, animated: true)
    }

    private func deleteAccount() {
        Auth.auth().currentUser?.delete() { (error) in
            if error == nil {
                self.navigationController?.popViewController(animated: true)
            } else {
                print("エラー:\(String(describing: error?.localizedDescription))")
            }
        }
    }

    private func deleteAccountData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).delete() { err in
            if let err = err {
                print("エラー:\(String(describing: err.localizedDescription))")
            }
        }
    }
}

extension UserDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = userDetailsTableView.dequeueReusableHeaderFooterView(withIdentifier: UserDetailsTableViewHeaderView.identifier) as! UserDetailsTableViewHeaderView

        header.configure(name: user?.name ?? "情報を取得中..", email: user?.email ?? "情報を取得中..")

        return header
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userDetailsTableView.dequeueReusableCell(withIdentifier: UserDetailsTableViewCell.identifier) as! UserDetailsTableViewCell

        let option = options[indexPath.row]
        let textColor: UIColor = option.textColorType == .warning ? .systemRed : .black

        cell.configure(option: option.item, textColor: textColor)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let cell = Cell(rawValue: indexPath.row)
        switch cell {
        case .logoutCell: showLogoutAlert()
        case .deleteAccountCell: showDeleteAuthAlert()
        default: break
        }
    }
}
