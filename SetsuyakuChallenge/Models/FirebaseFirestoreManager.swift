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
    func saveData(image: UIImage, name: String, goalAmount: Int) async throws {
        let fileName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child(StorageFileName.itemImage).child(fileName)

        let snapshot = await saveImageData(storageRef: storageRef, image: image)
        let imageURL = try await fetchImageURL(snapshot: snapshot)
        try await saveChallengeData(imageURL: imageURL, name: name, goalAmount: goalAmount)
    }


    // throwsをつけるとこのメソッドの呼び出し元でハンドリングを書くことになるので、単純にエラーを返したいだけならdo-catchは不要
    func saveChallengeData(imageURL: String, name: String, goalAmount: Int) async throws {
        // 設定する目標のModelをインスタンス化してユーザーの入力値を初期値として与える
        let challenge = Challenge(imageURL: imageURL, name: name, goalAmount: goalAmount, reports: [], totalSavingAmount: 0, isChallenge: true)
        // Firestoreに登録されているユーザー自身のIDを取得
        guard let uid = Auth.auth().currentUser?.uid else { return }
        // 🍎ハードコーディング対策としてenumでstringを管理しているものと思われるがこの書き方は第三者からみて有用と言えるのか知りたい
        let challengeRef = Firestore.firestore().collection(CollectionName.users).document(uid).collection(CollectionName.challenges)
        try challengeRef.document().setData(from: challenge)
    }

    // 保存した画像のURLを取得
    private func fetchImageURL(snapshot: StorageTaskSnapshot) async throws  -> String {
        let imageURL = try await snapshot.reference.downloadURL()
        let stringImageURL = imageURL.absoluteString
        return stringImageURL
    }

    // 画像の保存処理
    private func saveImageData(storageRef: StorageReference, image: UIImage)async -> StorageTaskSnapshot {
        let uploadImage = image.jpegData(compressionQuality: 0.3) ?? Data()
        let uploadtTask = storageRef.putData(uploadImage)

        return await withCheckedContinuation { continuation in
            uploadtTask.observe(.success) { snapshot in
                continuation.resume(returning: snapshot)
            }
            uploadtTask.observe(.failure) { snapshot in
                continuation.resume(throwing: snapshot.error as! Never)
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
