//
//  CreateChallengeViewController.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/24.
//

import UIKit

final class CreateChallengeViewController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var goalAmountTextField: UITextField!
    @IBOutlet private weak var createChallengeButton: UIButton!
    @IBOutlet private weak var indicator: UIActivityIndicatorView!

    @IBAction private func didTapUploadImageButton(_ sender: Any) {
        showPickerController()
    }

    @IBAction private func didTapCreateChallengeButton(_ sender: Any) {
        Task { @MainActor in
            await saveData()
        }
    }
    // 同じ処理を一括で実行する為に複数のtextFieldを一つのプロパティにまとめる
    private var textFields: [UITextField] { [nameTextField, goalAmountTextField] }
    
    // FirebaseFirestore(データの保存/取得など)を管理するモデルのインスタンスを生成して格納
    private let firebaseFirestoreManager = FirebaseFirestoreManager()
    
    // ハードコーディング対策
    static let storyboardName = "CreateChallenge"
    static let identifier = "CreateChallenge"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButton()
        setUpTextFiled()
        indicator.isHidden = true
    }

    // チャレンジの作成を実行
    private func saveData() async {
        // goalAmountTextFieldの入力値をInt型に変換
        let inputPrice = goalAmountTextField.textToInt

        // 文字列を入力した場合はInt型に変換ができずnilが返る為、Alertを表示させる
        guard inputPrice != nil else {
            showInputErrorAlert()
            return
        }

        startIndicator()

        // スコープから抜ける時に呼び出される処理
        // 後始末で絶対に行いたい処理で使える
        // defer通過前でreturnが呼ばれた場合などはdeferの中の処理が走ることはない
        defer {
            stopIndicator()
        }

        do {
            try await firebaseFirestoreManager.newSaveData(image: imageView.image!, name: nameTextField.text!, goalAmount: inputPrice!)
//            stopIndicator()
            navigationController?.popViewController(animated: true)
        } catch {
//            stopIndicator()
            showSaveDataErrorAlert(error: error as NSError)
        }

        // 👇Before
//        firebaseFirestoreManager.executeSaveData(image: imageView.image!, name: nameTextField.text!, goalAmount: inputPrice!, completion: { [weak self] result in
//            self?.stopIndicator()
//            switch result {
//            case .success:
//                self?.navigationController?.popViewController(animated: true)
//            case .failure(let error):
//                self?.showSaveDataErrorAlert(error: error)
//            }
//        })
    }


    // 写真のライブラリを表示する画面を表示
    private func showPickerController() {
        let pickerController = generatePickerController()
        setUpPickerController(pickerController: pickerController)
        present(pickerController, animated: true)
    }

    // インジケーターを開始
    private func startIndicator() {
        indicator.isHidden = false
        view.alpha = 0.5
        indicator.startAnimating()
    }

    // インジケーターを停止
    private func stopIndicator() {
        indicator.stopAnimating()
        indicator.isHidden = true
        view.alpha = 1.0
    }

    // データの保存失敗時に表示するアラートを表示
    private func showSaveDataErrorAlert(error: NSError) {
        let errorMessage = firebaseFirestoreManager.getFirestoreErrorMessage(error: error)
        let alertController = UIAlertController(title: AlertTitle.saveDataError, message: errorMessage, preferredStyle: .alert)

        // ボタンをタップすると再度保存を実行する
//        alertController.addAction(UIAlertAction(title: AlertAction.retry, style: .default, handler: { [weak self] _ in
//            await self?.saveData() }))
        alertController.addAction(UIAlertAction(title: AlertAction.retry, style: .default, handler: {_ in }))

        alertController.addAction(UIAlertAction(title: AlertAction.cancel, style: .cancel))
        present(alertController, animated: true)
    }

    // ユーザーが金額を入力する箇所に数値型以外の値を入力した場合にエラーを伝えるアラートを表示
    private func showInputErrorAlert() {
        let alertController = UIAlertController(title: AlertTitle.inputError, message: AlertMessage.inputError, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: AlertAction.ok, style: .default))

        present(alertController, animated: true)
    }

    // 写真のライブラリを表示する画面を生成
    private func generatePickerController() -> UIImagePickerController {
        let pickerController = UIImagePickerController()
        return pickerController
    }

    private func setUpPickerController(pickerController: UIImagePickerController) {
        pickerController.delegate = self
        // 画像の切り取り等を可能にする
        pickerController.allowsEditing = true
    }

    // ボタンに丸みを加えアプリのテーマカラーを設定
    private func setUpButton() {
        createChallengeButton.mainButton()
    }

    private func setUpTextFiled() {
        textFields.forEach { $0.delegate = self }
        setUpNumberPad()
    }

    // goalAmountTextFieldのキーボードタイプを数値入力型に変換
    private func setUpNumberPad() {
        goalAmountTextField.keyboardType = .numberPad
    }
}

// 画面上の全てのtextFieldに値が存在する場合のみ、チャレンジ作成を実行するボタンをタップできる
extension CreateChallengeViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let textsIsEmpty = textFields.map { $0.text?.isEmpty ?? true }

        if textsIsEmpty[0] || textsIsEmpty[1] {
            createChallengeButton.isEnabled = false
        } else {
            createChallengeButton.isEnabled = true
        }
    }
}

extension CreateChallengeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // UIImagePickerControllerのライブラリから画像を選択後、CreαteChallengeViewController上のUIImageViewに選択した画像を表示
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            self.imageView.image = image
        }
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
