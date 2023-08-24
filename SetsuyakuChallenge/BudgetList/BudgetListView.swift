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
        BudgetCategory(icon: BudgetItem.food.icon, name: BudgetItem.food.name, budget: 40000),
        BudgetCategory(icon: BudgetItem.transport.icon, name: BudgetItem.transport.name, budget: 15000),
        BudgetCategory(icon: BudgetItem.dailyNecessities.icon, name: BudgetItem.dailyNecessities.name, budget: 30000    )
    ]


    var body: some View {
        GeometryReader { geometry in
            List {
                Section {
                    HStack {
                        Text("今月の予算：")
                            .bold()
                            .lineLimit(0)
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
                                .frame(
                                    width: geometry.size.width,
                                    height: geometry.size.height * 0.06
                                )
                        }
                    }
                } header: {
                    Text("カテゴリ別予算")
                }
            }
            .listStyle(.grouped)
        }
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
        GeometryReader { geometry in
            HStack(alignment: .center, spacing: 10) {
                VStack {
                    Text(budgetCategory.icon)
                        .bold()
                        .lineLimit(0)
                    Spacer()
                    Text(budgetCategory.name)
                        .bold()
                        .lineLimit(0)
                }
                .frame(width: geometry.size.width * 0.2)
                VStack(alignment: .leading, spacing: 4) {
                    Text("残 ¥\(budgetCategory.budget - 10000)")
                        .lineLimit(0)
                    Text("¥\(budgetCategory.budget)")
                        .foregroundColor(.secondary)
                        .lineLimit(0)
                }
                .frame(
                    width: geometry.size.width * 0.25,
                    alignment: .leading
                )
                if #available(iOS 14.0, *) {
                    ProgressView(value: 0.3)
                        .frame(width: geometry.size.width * 0.4)
                } else {
                    // Fallback on earlier versions
                }
                DisclosureIndicator()
                    .frame(width: geometry.size.width * 0.05)
            }
        }
    }
}

struct DisclosureIndicator: View {
    var body: some View {
        Image(systemName: "chevron.right")
            .foregroundColor(.gray)
    }
}
