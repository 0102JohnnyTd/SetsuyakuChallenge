//
//  Challenge.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/26.
//

import Foundation
import UIKit

struct Challenge: Codable {
    var imageURL: String
    var name: String
    var goalAmount: Int
    var reports: [SaveMoneyReport]
    var totalSavingAmount: Int
    var isChallenge: Bool

    var docID: String?
}
