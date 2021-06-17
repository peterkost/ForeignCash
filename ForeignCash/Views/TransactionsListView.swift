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
                Button("Add Stuff") {
                    transactions.addTransaction(title: "Test", descirption: "TestDesc", amount: 123, type: "Add")
                }
                ForEach(transactions.items) { transaction in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(transaction.title)
                                .font(.headline)
                            Text(transaction.type)
                        }
                        Spacer()
                        Text("$\(transaction.amount)")
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
        transactions.items.remove(atOffsets: offset)
    }
}

struct TransactionsListView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsListView()
    }
}