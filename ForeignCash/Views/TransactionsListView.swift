//
//  TransactionView.swift
//  ForeignCash
//
//  Created by Peter Kostin on 2021-06-17.
//

import SwiftUI

struct TransactionsListView: View {
    @EnvironmentObject var currencyPairs: CurrencyPairs
    @State private var showingAddTransaction = false
    @State private var reload = true
    
    var body: some View {
        NavigationView {
            List {
                ForEach(currencyPairs.selectedPair!.sortedByDate) { transaction in
                    NavigationLink(destination: TransactionDetailsView(transaction: transaction)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(transaction.title)
                                    .font(.headline)
                                Text(Formatter().shortDateTime(date: transaction.date))
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("\(transaction.forexAmount, specifier: "%.2f") \(currencyPairs.selectedPair!.to)")
                                Text("\(transaction.homeAmount, specifier: "%.2f") \(currencyPairs.selectedPair!.from)")
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
                    .environmentObject(currencyPairs)
            })
        }
    }
    
    func removeItems(at offset: IndexSet) {
        let index = offset[offset.startIndex]
        let target = currencyPairs.selectedPair!.sortedByDate[index]
        currencyPairs.objectWillChange.send()
        currencyPairs.selectedPair!.deleteTransactionWithID(target.id)
    }
}

struct TransactionsListView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsListView()
    }
}
