//
//  TransactionView.swift
//  ForeignCash
//
//  Created by Peter Kostin on 2021-06-17.
//

import SwiftUI

struct TransactionsListView: View {
    @EnvironmentObject var transactions: Transactions
    @State private var showingAddTransaction = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(transactions.sortedByDate) { transaction in
                    NavigationLink(destination: TransactionDetailsView(transaction: transaction)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(transaction.title)
                                    .font(.headline)
                                Text(Formatter().shortDateTime(date: transaction.date))
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("\(transaction.forexAmount, specifier: "%.2f")₽")
                                Text("$\(transaction.homeAmount, specifier: "%.2f")")
                            }
                            .foregroundColor(transaction.forexAmount > 0 ? .green : .red)
                        }
                    }
                }
                .onDelete(perform: removeItems)
            }
            .navigationBarTitle("Transactions")
            .navigationBarItems(
                leading: EditButton(),
                trailing: Button(action: { showingAddTransaction = true }) {
                    Image(systemName: "plus") })
            .sheet(isPresented: $showingAddTransaction, content: {
                AddTransactionView()
                    .environmentObject(transactions)
            })
        }
    }
    
    func removeItems(at offset: IndexSet) {
        let index = offset[offset.startIndex]
        let target = transactions.sortedByDate[index]
        transactions.deleteTransactionWithID(target.id)
    }
}

struct TransactionsListView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsListView()
    }
}
