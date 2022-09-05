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
    @IBOutlet private weak var itemImageView: UIImageView!
    @IBOutlet private weak var itemTextField: UITextField!
    @IBOutlet private weak var priceTextField: UITextField!
    @IBOutlet private weak var createChallengeButton: UIButton!

    @IBAction private func didTapUploadImageButton(_ sender: Any) {
        showPickerController()
    }
    @IBAction private func didTapCreateChallengeButton(_ sender: Any) {
        checkIsTextField()
    }

    private var textFields: [UITextField] { [itemTextField, priceTextField] }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButton()
        setUpTextFiled()
    }

    private func checkIsTextField() {
        let inputPrice = priceTextField.textToInt

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
        let fileName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("item_image").child(fileName)
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
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let itemName = itemTextField.text!
        let itemPrice = priceTextField.text!

        let docData = ["ImageURL": imageURL, "name": itemName, "price": itemPrice] as [String: Any]
        let userRef = Firestore.firestore().collection("challenges").document(uid)

        userRef.setData(docData) { (err) in
            if let err = err {
            print("FireStroreへの保存に失敗しました: \(err)")
        }
            print("FireStoreへの保存に成功しました")
        }
    }

    private func saveImageData(storageRef: StorageReference) {
        let image = itemImageView.image!
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
        priceTextField.keyboardType = .numberPad
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
            self.itemImageView.image = image
        }
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
