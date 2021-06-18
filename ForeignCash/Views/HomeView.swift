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
                    VStack {
                        Text("\(transactions.forexTotal, specifier: "%.2f")₽")
                            .font(.largeTitle)
                            .frame(maxWidth: .infinity,  alignment: .center)
                        
                        Text("$\(transactions.homeTotal, specifier: "%.2f")")
                            .font(.title2)
                            .frame(maxWidth: .infinity,  alignment: .center)
                    }
//                    Text("Average price for 100 RUB: &\(transactions.averageForexPrice * 100 , specifier: "%.2f")")
                }
                
                Section(header: Text("Recent Transactions")) {
                    List {
                        ForEach(transactions.items) { transaction in
                            Text("\(transaction.forexAmount)")
                        }
                    }
                }
                
                Section(header: Text("ForEx")) {
                    List {
                        Text("Your average rate is \(1/transactions.averageForexPrice , specifier: "%.2f")₽/$")
                        Text("Current rate: \("TODO")")
                    }
                }
            }
            .navigationBarTitle("Ruble 🇷🇺")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
