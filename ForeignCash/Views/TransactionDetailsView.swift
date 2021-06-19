//
//  TransactionDetailsView.swift
//  ForeignCash
//
//  Created by Peter Kostin on 2021-06-18.
//

import SwiftUI

struct TransactionDetailsView: View {
    let transaction: Transaction
    
    var body: some View {
        Form {
            Section {
                VStack {
                    Text("\(transaction.forexAmount, specifier: "%.2f")")
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity,  alignment: .center)
                    
                    Text("\(transaction.homeAmount, specifier: "%.2f")")
                        .font(.title2)
                        .frame(maxWidth: .infinity,  alignment: .center)
                }
            }
            Section(header: Text("date")) {
                Text(Formatter().medtDateTime(date: transaction.date))
            }
            
            Section(header: Text("comment")) {
                Text(transaction.description)
            }
        }
        .navigationBarTitle(transaction.title)
    }
}

struct TransactionDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionDetailsView(transaction: Transaction(id: UUID(), date: Date(), title: "Sbermarket", description: "Courier tip", type: "Spend", forexAmount: 100, homeAmount: 2))
    }
}
