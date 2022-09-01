//
//  PriceManager.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/09/01.
//

import Foundation

protocol PriceManagerDelegate: AnyObject {
    func didChangePrice()
}

final class PriceManager {
    static let shared = PriceManager()
    private init() {}

    weak var delegate: PriceManagerDelegate?

    private(set) var totalPrice = 0

    func calculate(price: Int) {
        totalPrice += price
        notify()
    }

    private func notify() {
        delegate?.didChangePrice()
    }
}
