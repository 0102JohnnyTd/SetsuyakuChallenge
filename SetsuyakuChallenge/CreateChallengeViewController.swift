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


final class CreateChallengeViewController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var goalAmountTextField: UITextField!
    @IBOutlet private weak var createChallengeButton: UIButton!

    @IBAction private func didTapUploadImageButton(_ sender: Any) {
        showPickerController()
    }
    @IBAction private func didTapCreateChallengeButton(_ sender: Any) {
        checkIsTextField()
    }

    private var textFields: [UITextField] { [nameTextField, goalAmountTextField] }

    private let fileName = NSUUID().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButton()
        setUpTextFiled()
    }

    private func checkIsTextField() {
        let inputPrice = goalAmountTextField.textToInt

        guard inputPrice != nil else {
            showAlert()
            return
        }
        saveData()
        navigationController?.popViewController(animated: true)
    }

    private func showAlert() {
        let alertController = generateInputErrorAlert()
        present(alertController, animated: true)
    }

    private func showPickerController() {
        let pickerController = generatePickerController()
        setUpPickerController(pickerController: pickerController)
        present(pickerController, animated: true)
    }

    private func saveData() {

        let storageRef = Storage.storage().reference().child(StorageFileName.itemImage).child(fileName)
        saveImageData(storageRef: storageRef)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.fetchImageURL(storageRef: storageRef)
        }
    }

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

    private func saveChallengeData(imageURL: String) {
        let name = nameTextField.text!
        let goalAmount = goalAmountTextField.text!

        let docData = [ChallengesDocDataKey.imageURL: imageURL, ChallengesDocDataKey.name: name, ChallengesDocDataKey.goalAmount: goalAmount] as [String: Any]

        let challengeRef = Firestore.firestore().collection(CollectionName.challenges).document(fileName)
        challengeRef.setData(docData) { (err) in
            if let err = err {
            print("FireStroreへの保存に失敗しました: \(err)")
        }
            print("FireStoreへの保存に成功しました")
        }
    }

    private func saveImageData(storageRef: StorageReference) {
        let image = imageView.image!
        guard let uploadImage = image.jpegData(compressionQuality: 0.3) else { return }

        storageRef.putData(uploadImage) { (metaData, err) in
            if let err = err {
                print("Firestorageへの情報の保存に失敗しました \(err)")
                return
            }
            print("Firestorageへの情報の保存に成功しました")
        }
    }

    private func generateInputErrorAlert() -> UIAlertController {
        let alertController = UIAlertController(title: AlertTitle.inputError, message: AlertMessage.inputError, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: AlertAction.ok, style: .default))

        return alertController
    }

    private func generatePickerController() -> UIImagePickerController {
        let pickerController = UIImagePickerController()
        return pickerController
    }

    private func setUpPickerController(pickerController: UIImagePickerController) {
        pickerController.delegate = self
        pickerController.allowsEditing = true
    }

    private func setUpButton() {
        createChallengeButton.mainButton()
    }

    private func setUpTextFiled() {
        textFields.forEach { $0.delegate = self }
        setUpNumberPad()
    }

    private func setUpNumberPad() {
        goalAmountTextField.keyboardType = .numberPad
    }
}

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
