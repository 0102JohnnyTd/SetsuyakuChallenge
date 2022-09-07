//
//  SaveMoneyReport.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/08/31.
//

import Foundation

struct SaveMoneyReport {
    var savingAmount: Int
    var memo: String

    static var array: [SaveMoneyReport] = []

    init(dic: [String: Any]) {
        self.savingAmount = dic[SaveMoneyReportsDocDataKey.savingAmount] as! Int
        self.memo = dic[SaveMoneyReportsDocDataKey.memo] as! String
    }
}
