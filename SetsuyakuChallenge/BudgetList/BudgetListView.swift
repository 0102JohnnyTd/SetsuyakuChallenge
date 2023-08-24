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

//    private let 残額と合計額の2行文字列の幅 =

@available(iOS 14.0, *)
var body: some View {
        GeometryReader { geometry in
            List {
                Section {
                    HStack(alignment: .center) {
                        VStack {
                            Text("💰")
                                .lineLimit(0)
                            Spacer()
                            Text("予算")
                                .bold()
                                .lineLimit(0)
                        }.frame(
                            width: geometry.size.width * ObjectSize.budgetName.width,
                            height: geometry.size.height * 0.06,
                            alignment: .leading
                        )

                        VStack(alignment: .leading, spacing: 0) {
                            Text("残 ¥\(27000)")
                            Text("¥\(90000)")
                                .foregroundColor(.secondary)
                        }.frame(
                            width: geometry.size.width * ObjectSize.budget.width,
                            alignment: .leading
                        )
                        ProgressView(value: 0.7)
                            .frame(
                                width: geometry.size.width * ObjectSize.progressView.width)
                        DisclosureIndicator()
                            .frame(
                                width: ObjectSize.disclosureIndicator.width
                            )
//                        frame(
//                            width: geometry.size.width * 0.8,
//                            alignment: .leading
//                        )
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
            HStack(alignment: .center) {
                VStack {
                    Text(budgetCategory.icon)
                        .lineLimit(0)
                    Spacer()
                    Text(budgetCategory.name)
                        .bold()
                        .lineLimit(0)
                }
                .frame(width: geometry.size.width * ObjectSize.budgetName.width)
                VStack(alignment: .leading, spacing: 4) {
                    Text("残 ¥\(budgetCategory.budget - 10000)")
                        .lineLimit(0)
                    Text("¥\(budgetCategory.budget)")
                        .foregroundColor(.secondary)
                        .lineLimit(0)
                }
                .frame(
                    width: geometry.size.width * ObjectSize.budget.width,
                    alignment: .leading
                )
                if #available(iOS 14.0, *) {
                    ProgressView(value: 0.3)
                        .frame(width: geometry.size.width * ObjectSize.progressView.width)
                } else {
                    // Fallback on earlier versions
                }
                DisclosureIndicator()
                    .frame(width: geometry.size.width * ObjectSize.disclosureIndicator.width)
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
