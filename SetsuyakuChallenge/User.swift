//
//  User.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/11.
//

import Foundation
import FirebaseFirestore

struct User {
    let email: String
    let createdAt: Timestamp
    let name: String

    init(dic: [String: Any]) {
        self.email = dic["email"] as! String
        self.createdAt = dic["createdAt"] as! Timestamp
//        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
        self.name = dic["name"] as! String
    }
}
