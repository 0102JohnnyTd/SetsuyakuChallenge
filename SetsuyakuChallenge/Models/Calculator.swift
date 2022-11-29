//
//  Calculator.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/11/18.
//

import Foundation

protocol CalculatorDelegate: AnyObject {
    func didChangeSign()
}

final class Calculator {
    weak var delegate: CalculatorDelegate?
    // 値の符号の切り替え
    func signSwitch(isOn: Bool, value: Int) -> Int {
        let signCount = isOn ? value : -value
        notifyDidChangeSign()
        return signCount
    }

    // 引数reportsに渡す値はchallenge?.reportsになるので、FirebaseのModelでこのメソッドをよばければいけない？でも設計上おかしい気がする。。
    func sum(reports: [SaveMoneyReport]) -> Int {
        let sum = reports.reduce(0) { $0 + $1.savingAmount }
        return sum
//        challenge?.reports.reduce(0) { $0 + $1.savingAmount } ?? 0
    }

    func notifyDidChangeSign() {
        delegate?.didChangeSign()
    }
}
