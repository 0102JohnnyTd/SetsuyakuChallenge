//
//  BudgetListView.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2023/07/23.
//

import SwiftUI

@available(iOS 14.0, *)
struct BudgetListView: View {
    let budgetCategory = BudgetCategory(
        icon: BudgetItem.money.icon,
        name: BudgetItem.money.name,
        budget: 70000
    )

    let budgetList = [
        BudgetCategory(icon: BudgetItem.food.icon, name: BudgetItem.food.name, budget: 40000),
        BudgetCategory(icon: BudgetItem.transport.icon, name: BudgetItem.transport.name, budget: 15000),
        BudgetCategory(icon: BudgetItem.dailyNecessities.icon, name: BudgetItem.dailyNecessities.name, budget: 30000    )
    ]

    @available(iOS 14.0, *)
    var body: some View {
        GeometryReader { geometry in
            List {
                Section {
                    BudgetListRowView(budgetCategory: budgetCategory)
                        .frame(
                            width: geometry.size.width,
                            height: geometry.size.height * 0.06
                        )
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

@available(iOS 14.0, *)
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
                .frame(
                    width: geometry.size.width * ObjectSize.budgetName.width,
                    alignment: .center
                )
                VStack(alignment: .leading) {
                    //                    Text("幅: \(geometry.size.width)")
                    //                    Text("高さ：\(geometry.size.height)")
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
                ProgressView(value: 0.3)
                    .frame(width: geometry.size.width * ObjectSize.progressView.width)
                DisclosureIndicator()
                    .frame(
                        width: geometry.size.width * ObjectSize.disclosureIndicator.width,
                        alignment: .trailing
                    )
                    .onTapGesture {
                        print("カテゴリ別予算がタップされた")
                    }
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
