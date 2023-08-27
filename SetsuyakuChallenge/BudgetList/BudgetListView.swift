//
//  BudgetListView.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2023/07/23.
//

import SwiftUI

// Rowのレイアウトを持つ
struct ListRowLayoutView<T: View, U: View, V: View, W: View>: View {
    private enum ObjectWidthRatio {
        static var budgetName: CGFloat { 0.16 }
        static var budget: CGFloat { 0.25 }
        static var progressView: CGFloat { 0.4 }
        static var disclosureIndicator: CGFloat { 0.05 }
    }

    let first: () -> T
    let second: () -> U
    let third: () -> V
    let fourth: () -> W

    var body: some View {
        GeometryReader { geometry in
            HStack {
                first()
                    .frame(
                        width: geometry.size.width * ObjectWidthRatio.budgetName,
                        alignment: .center
                    )
                second()
                    .frame(
                        width: geometry.size.width * ObjectWidthRatio.budget,
                        alignment: .leading
                    )
                third()
                    .frame(
                        width: geometry.size.width * ObjectWidthRatio.progressView,
                        alignment: .leading
                    )
                fourth()
                    .frame(
                        width: geometry.size.width * ObjectWidthRatio.disclosureIndicator,
                        alignment: .trailing
                    )
                    .onTapGesture {
                        print("カテゴリ別予算がタップされた")
                    }
            }
        }
    }
}

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
        ListRowLayoutView(
            first: {
                VStack {
                    Text(budgetCategory.icon)
                        .lineLimit(0)
                    Spacer()
                    Text(budgetCategory.name)
                        .bold()
                        .lineLimit(0)
                }
            },
            second: {
                VStack(alignment: .leading) {
                    Text("残 ¥\(budgetCategory.budget - 10000)")
                        .lineLimit(0)
                    Text("¥\(budgetCategory.budget)")
                        .foregroundColor(.secondary)
                        .lineLimit(0)
                }
            },
            third: { ProgressView(value: 0.3) },
            fourth: { DisclosureIndicator() }
        )
    }
}

struct DisclosureIndicator: View {
    var body: some View {
        Image(systemName: "chevron.right")
            .foregroundColor(.gray)
    }
}
