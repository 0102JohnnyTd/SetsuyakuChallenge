//
//  CreateChallengeViewController.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import FirebaseFirestoreSwift


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
        checkIsTextField()
    }

    // 同じ処理を一括で実行する為に複数のtextFieldを一つのプロパティにまとめる
    private var textFields: [UITextField] { [nameTextField, goalAmountTextField] }

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
    private func checkIsTextField() {
        // goalAmountTextFieldの入力値をInt型に変換
        let inputPrice = goalAmountTextField.textToInt

        // 文字列を入力した場合はInt型に変換ができずnilが返る為、Alertを表示させる
        guard inputPrice != nil else {
            showAlert()
            return
        }
        saveData()
        startIndicator()
        // ⛏escapingクロージャを使った処理なら時間差をつけなくても順を守って動いてくれそうなので要修正
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.stopIndicator()
            self.navigationController?.popViewController(animated: true)
        }
    }

    // ユーザーが金額を入力する箇所に数値型以外の値を入力した場合にエラーを伝えるアラートを表示
    private func showAlert() {
        let alertController = generateInputErrorAlert()
        present(alertController, animated: true)
    }

    // 写真のライブラリを表示する画面を表示
    private func showPickerController() {
        let pickerController = generatePickerController()
        setUpPickerController(pickerController: pickerController)
        present(pickerController, animated: true)
    }


    // Firebaseへの保存処理をまとめて実行する
    private func saveData() {
        // ❓本当にUUIDを生成する必要があるのか要調査
        let fileName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child(StorageFileName.itemImage).child(fileName)

        saveImageData(storageRef: storageRef)
        // 先にUIImageの保存を完了させないと画像URLが取得できない為、時間差をつけてfetchImageURLメソッドを実行
        // ⛏escapingクロージャを使った処理なら時間差をつけなくても順を守って動いてくれそうなので要修正
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.fetchImageURL(storageRef: storageRef)
        }
    }

    // Firebaseのstorageに保存された画像のurlを取得してsaveChallengeDataの引数に当てる
    private func fetchImageURL(storageRef: StorageReference) {
        storageRef.downloadURL { (url, err) in
            if let err = err {
                print("Firestorageのデータの取得に失敗しました \(err)")
                return
            }
            print("Firestorageのデータの取得に成功しました")
            guard let itemImageURL = url?.absoluteString else { return }
            self.saveChallengeData(imageURL: itemImageURL)
        }
    }

    // ユーザーが入力したチャレンジ内容をFirestoreに保存
    private func saveChallengeData(imageURL: String) {
        let name = nameTextField.text!
        let goalAmount = goalAmountTextField.textToInt!

        let challenge = Challenge(imageURL: imageURL, name: name, goalAmount: goalAmount, reports: [], totalSavingAmount: 0, isChallenge: true)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let challengeRef = Firestore.firestore().collection(CollectionName.users).document(uid).collection(CollectionName.challenges)
        do {
            try challengeRef.document().setData(from: challenge)
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }

    // Firebaseのstorageにユーザーが選択した画像もしくはデフォルトの画像を保存
    private func saveImageData(storageRef: StorageReference) {
        let image = imageView.image!
        guard let uploadImage = image.jpegData(compressionQuality: 0.3) else { return }

        storageRef.putData(uploadImage, metadata: nil) { storageMetadata, err in
            if let err = err {
                print("Firestorageへの情報の保存に失敗しました \(err)")
                return
            }
            print("Firestorageへの情報の保存に成功しました")
        }
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

    // ユーザーが金額を入力する箇所に数値型以外の値を入力した場合にエラーを伝えるアラートを生成
    private func generateInputErrorAlert() -> UIAlertController {
        let alertController = UIAlertController(title: AlertTitle.inputError, message: AlertMessage.inputError, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: AlertAction.ok, style: .default))

        return alertController
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            self.imageView.image = image
        }
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
