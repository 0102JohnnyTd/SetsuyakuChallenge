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

    private var textFields: [UITextField] { [nameTextField, goalAmountTextField] }

    static let storyboardName = "CreateChallenge"
    static let identifier = "CreateChallenge"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButton()
        setUpTextFiled()
        indicator.isHidden = true
    }

    private func checkIsTextField() {
        let inputPrice = goalAmountTextField.textToInt

        guard inputPrice != nil else {
            showAlert()
            return
        }
        saveData()
        startIndicator()
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.stopIndicator()
            self.navigationController?.popViewController(animated: true)
        }
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

    private func startIndicator() {
        indicator.isHidden = false
        view.alpha = 0.5
        indicator.startAnimating()
    }

    private func stopIndicator() {
        indicator.stopAnimating()
        indicator.isHidden = true
        view.alpha = 1.0
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