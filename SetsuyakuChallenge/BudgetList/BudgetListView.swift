//
//  BudgetListView.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2023/07/23.
//

import SwiftUI

@available(iOS 14.0, *)
struct BudgetListView: View {
    let budgetList = [
        BudgetCategory(name: "🍙 食事", budget: 40000),
        BudgetCategory(name: "🚃 交通", budget: 20000),
        BudgetCategory(name: "🧻 日用品", budget: 30000)
    ]


    var body: some View {
        List {
            Section {
                HStack {
                    Text("今月の予算：")
                        .bold()
                    VStack(alignment: .leading, spacing: 0) {
                        Text("残 ¥\(27000)")
                        Text("¥\(90000)")
                            .foregroundColor(.secondary)
                    }
                    ProgressView(value: 0.7)
                }
            } header: {
                Text("合計予算")
            }
            Section {
                ForEach(budgetList) { budgetCategory in
                    VStack {
                        BudgetListRowView(budgetCategory: budgetCategory)
                    }
                }
            } header: {
                Text("カテゴリ別予算")
            }
        }
        .listStyle(.grouped)
    }
}

struct BudgetListView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 14.0, *) {
            BudgetListView()
        } else {
            // Fallback on earlier versions
        }
    }
}

struct BudgetListRowView: View {
    var budgetCategory: BudgetCategory

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Text(budgetCategory.name)
                .bold()
                .frame(width: UIScreen.main.bounds.width * 0.25)
            VStack(alignment: .leading, spacing: 4) {
                Text("残 ¥\(budgetCategory.budget - 10000)")
                Text("¥\(budgetCategory.budget)")
                    .foregroundColor(.secondary)
            }
            if #available(iOS 14.0, *) {
                ProgressView(value: 0.3)
                    .frame(width: UIScreen.main.bounds.width * 0.4)
            } else {
                // Fallback on earlier versions
            }
        }
    }
}
