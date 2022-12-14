//
//  FirebaseFirestoreManager.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/11/24.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import FirebaseAuth

final class FirebaseFirestoreManager {
    // Controllerからデータを受け取るためのプロパティ
    private var challengeData: Challenge?
    private var challengesData: [Challenge] = []
    private var completedChallengesData: [Challenge] = []

    // MARK: - アカウント情報保存
    // Firestore上にデータの保存を行う
    func saveUserData(email: String, name: String, completion: (Result<User, NSError>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let user = User(email: email, name: name)

        let userRef = Firestore.firestore().collection(CollectionName.users).document(uid)

        do {
            try userRef.setData(from: user)
            completion(.success(user))
        } catch {
            completion(.failure(error as NSError))
        }
    }
    
    // MARK: - チャレンジの保存
    // Firestoreへの保存処理を実行
    func executeSaveData(image: UIImage, name: String, goalAmount: Int, completion: @escaping (Result<(), NSError>) -> Void) {
        let fileName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child(StorageFileName.itemImage).child(fileName)

        // ⛏switch文が入れ子になって可読性が微妙。async awaitを使うとスッキリ書ける。
        saveImageData(storageRef: storageRef, image: image) { [weak self] result in
            switch result {
            case .success:
                self?.saveChallengeData(storageRef: storageRef, name: name, goalAmount: goalAmount) { result in
                    switch result {
                    case .success:
                        completion(.success(()))
                    // Firestoreへチャレンジ内容の保存が失敗した場合、クロージャにNSError型の値を渡して実行
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            // Firestorageへ画像の保存が失敗した場合、クロージャにNSError型の値を渡して実行
            case .failure(let error as NSError):
                completion(.failure(error))
            }
        }
    }

    // ユーザーが入力したチャレンジ内容をFirestoreに保存
    private func saveChallengeData(storageRef: StorageReference, name: String, goalAmount: Int, completion: @escaping (Result<CollectionReference, NSError>) -> Void) {
        print(#function)
        fetchImageURL(storageRef: storageRef) { result in
            switch result {
            case .success(let imageURL):
                let challenge = Challenge(imageURL: imageURL, name: name, goalAmount: goalAmount, reports: [], totalSavingAmount: 0, isChallenge: true)
                guard let uid = Auth.auth().currentUser?.uid else { return }
                let challengeRef = Firestore.firestore().collection(CollectionName.users).document(uid).collection(CollectionName.challenges)
                do {
                    try challengeRef.document().setData(from: challenge)
                    completion(.success(challengeRef))
                } catch {
                    print("error: \(error.localizedDescription)")
                    completion(.failure(error as NSError))
                }
            case .failure(let error):
                // アラートを表示
                completion(.failure(error as NSError))
            }
        }
    }

    // Firebaseのstorageに保存された画像のurlを取得してsaveChallengeDataの引数に当てる
    private func fetchImageURL(storageRef: StorageReference, completion: @escaping (Result<String, NSError>) -> Void) {
        storageRef.downloadURL { url, err in
            if let err = err {
                completion(.failure(err as NSError))
                return
            }
            print("Firestorageのデータの取得に成功しました")
            guard let itemImageURL = url?.absoluteString else { return }
            completion(.success(itemImageURL))
        }
    }

    // Firebaseのstorageにユーザーが選択した画像もしくはデフォルトの画像を保存
    private func saveImageData(storageRef: StorageReference, image: UIImage, completion: @escaping (Result<StorageMetadata, Error>) -> Void) {
        print(#function)

        // ❓本来はUIKit入れるのは良くないと思われるので対策を調べて修正する必要あり
        guard let uploadImage = image.jpegData(compressionQuality: 0.3) else { return }

        storageRef.putData(uploadImage, metadata: nil) { storageMetaData, error in
            switch (storageMetaData, error) {
            case let (storageMetadata?, nil):
                // storageMetaDataはOptional型のクロージャなので暗黙的にescaping扱いされる。
                // Optional型がクロージャを持っている状態
                completion(.success(storageMetadata))
            case let (nil, error?):
                completion(.failure(error))
            case (.some, .some), (nil, nil):
                fatalError()
            }
        }
    }
    // MARK: - 節約メモの保存
    func saveReportData(challenge: Challenge?, memo: String, price: Int, completion: (Result<(), NSError>) -> Void) {
        challengeData = challenge
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let  challengeDocID = challengeData?.docID else { return }

        let saveMoneyReport = SaveMoneyReport(savingAmount: price, memo: memo)

        challengeData?.reports.append(saveMoneyReport)

        let challegenRef = Firestore.firestore().collection(CollectionName.users).document(uid).collection(CollectionName.challenges).document(challengeDocID)
        
        do {
            try challegenRef.setData(from: challengeData)
            completion(.success(()))
        } catch {
            print("error: \(error.localizedDescription)")
            completion(.failure(error as NSError))
        }
    }
    // MARK: - チャレンジの取得
    // Firestoreに保存されたチャレンジデータを取得
    func fetchChallengeData(completion: @escaping (Result<Challenge?, NSError>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let challengeRef = Firestore.firestore().collection(CollectionName.users).document(uid).collection(CollectionName.challenges)

        challengeRef.getDocuments { snapshots, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            snapshots?.documents.forEach { snapshot in
                do {
                    var challenge = try snapshot.data(as: Challenge.self)
                    // 取得したデータのドキュメントIDを渡す
                    challenge?.docID = snapshot.documentID
                    // 合計金額を表示させる
                    let totalSavingAmount = challenge?.reports.reduce(0) { $0 + $1.savingAmount } ?? 0
                    challenge?.totalSavingAmount = totalSavingAmount

                    completion(.success(challenge))
                } catch {
                    completion(.failure(error as NSError))
                }
            }
        }
    }
    // MARK: - 節約メモの取得
    // Firestoreに保存されているChallengeのreportデータを取得
    func fetchReportsData(challenge: Challenge?, completion: @escaping (Result<Challenge?, NSError>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let challengeDocID = challenge?.docID else { return }
        let challengeRef = Firestore.firestore().collection(CollectionName.users).document(uid).collection(CollectionName.challenges).document(challengeDocID)

        challengeRef.getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error as NSError))
                return
            }
            do {
                let challenge = try snapshot?.data(as: Challenge.self)
                completion(.success(challenge))
            } catch {
                completion(.failure(error as NSError))
            }
        }
    }

    // MARK: - ユーザー情報の取得
    // Firestoreに保存されているUserデータを取得
    func fetchUserData(completion: @escaping (Result<User?, NSError>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        Firestore.firestore().collection(CollectionName.users).document(uid).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error as NSError))
            }
            do {
                let user = try snapshot?.data(as: User.self)
                completion(.success(user))
            } catch {
                completion(.failure(error as NSError))
            }
        }
    }
    // MARK: - Firestoreに保存されているデータの更新
    // FireStoreに保存された値を更新
    func updateData(challenge: Challenge, completion: @escaping (NSError) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let challengeID = challenge.docID else { return }
        let challengeRef = Firestore.firestore().collection(CollectionName.users).document(uid).collection(CollectionName.challenges).document(challengeID)

        challengeRef.updateData([FieldValue.isChallenge: false]) { err in
            if let err = err {
                completion(err as NSError)
            } else {
                print("Document successfully updated")
            }
        }
    }
    // MARK: - アカウント情報の削除を実行
    // FireStoreに保存されているUserデータの削除を実行
    func deleteAccountData(completion: @escaping (NSError) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection(CollectionName.users).document(uid).delete() { error in
            if let error = error {
                completion(error as NSError)
            }
        }
    }
    // MARK: - 合計節約金額が目標節約金額に届いているかの判断を行う処理
    // 合計節約金額が目標金額以上に到達した場合、チャレンジ達成のアラートを表示させる
    func compareValue(challenges: [Challenge], completion: @escaping (Result<EnumeratedSequence<[Challenge]>.Element, NSError>) -> Void) {
        challengesData = challenges
        challengesData.enumerated().forEach {
            if $0.element.totalSavingAmount >= $0.element.goalAmount {
                let index = $0.offset
                challengesData[index].isChallenge.toggle()
                updateData(challenge: $0.element, completion: { error in
                    completion(.failure(error))
                })
                completion(.success($0))
            }
            print("どの値も目標達成してないぜ")
        }
    }

    // MARK: - データの保存や取得失敗時に表示するエラーメッセージを取得する処理
    // データの保存失敗時に表示するエラーメッセージを取得
    func getFirestoreErrorMessage(error: NSError) -> String {
        if let errCode = FirestoreErrorCode(rawValue: error.code) {
            switch errCode {
            case .alreadyExists: return AlertMessage.alreadyExists
            case .notFound: return AlertMessage.dataNotFound
            default: return AlertMessage.someErrors
            }
        }
        // ❓これ消したいなあ
        return ""
    }
}
