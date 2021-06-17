//
//  HomeView.swift
//  ForeignCash
//
//  Created by Peter Kostin on 2021-06-17.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var transactions: Transactions
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Current Balance")) {
                    Text("\(transactions.total)")
                }
                
                Section(header: Text("Recent Transactions")) {
                    List {
                        ForEach(transactions.items) { transaction in
                            Text("\(transaction.amount)")
                        }
                    }
                }
                
                Section(header: Text("ForEx")) {
                    List {
                        Text("Your average rate: \("TODO")")
                        Text("Current rate: \("TODO")")
                    }
                }
            }
            .navigationBarTitle("Home")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
