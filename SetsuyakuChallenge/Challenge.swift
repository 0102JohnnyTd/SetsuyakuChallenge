//
//  Challenge.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/26.
//

import Foundation
import UIKit

struct Challenge {
    var imageURL: String
    var name: String
    var goalAmount: Int

    init(dic: [String: Any]) {
        self.imageURL = dic[ChallengesDocDataKey.imageURL] as! String
        self.name = dic[ChallengesDocDataKey.name] as! String
        self.goalAmount = dic[ChallengesDocDataKey.goalAmount] as! Int
    }
}
