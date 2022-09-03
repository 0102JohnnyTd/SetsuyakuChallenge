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
    @IBOutlet private weak var itemImage: UIImageView!
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
        createChallenge()
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

    private func saveImageData(storageRef: StorageReference) {
        let image = itemImage.image!
        guard let uploadImage = image.jpegData(compressionQuality: 0.3) else { return }

        storageRef.putData(uploadImage) { (metaData, err) in
            if let err = err {
                print("Firestorageへの情報の保存に失敗しました \(err)")
                return
            }
            print("Firestorageへの情報の保存に成功しました")
        }
    }

    private func createChallenge() {
        let challenge = Challenge(itemImage: itemImage.image!, itemName: itemTextField.text!, itemPrice: priceTextField.text!)
        Challenge.array.append(challenge)
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
            self.itemImage.image = image
        }
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
