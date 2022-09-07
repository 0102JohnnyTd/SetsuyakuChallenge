//
//  FirebaseValueManager.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/09/05.
//

import Foundation

enum StorageFileName {
    static let itemImage = "item_image"
}

enum CollectionName {
    static let users = "users"
    static let challenges = "challenges"
    static let reports = "reports"
}

enum UsersDocDataKey {
    static let email = "email"
    static let name = "name"
    static let createdAt = "createdAt"
}

enum ChallengesDocDataKey {
    static let imageURL = "imageURL"
    static let name = "name"
    static let goalAmount = "goalAmount"
}
