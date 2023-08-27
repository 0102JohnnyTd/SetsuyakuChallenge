//
//  ObjectSize.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2023/08/24.
//

import Foundation

enum ObjectSize {
    case budgetName
    case budget
    case progressView
    case disclosureIndicator

    var width: CGFloat {
        switch self {
        case .budgetName: return 0.16
        case .budget: return 0.25
        case .progressView: return 0.4
        case .disclosureIndicator: return 0.05
        }
    }
}
