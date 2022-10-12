//
//  User.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/11.
//

import Foundation
import FirebaseFirestore

struct User: Codable {
    let email: String
    let createdAt: Timestamp
    let name: String

//    init(dic: [String: Any]) {
//        self.email = dic[UsersDocDataKey.email] as! String
//        self.name = dic[UsersDocDataKey.name] as! String
//        self.createdAt = dic[UsersDocDataKey.createdAt] as! Timestamp
//    }
}
