//
//  HomeView.swift
//  ForeignCash
//
//  Created by Peter Kostin on 2021-06-17.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var transactions: CurrencyPair
    @State private var showingActionSheet = false
    @State private var showingNewCurrency = false

    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Current Balance")) {
                    VStack {
                        Text("\(transactions.forexTotal, specifier: "%.2f")₽")
                            .font(.largeTitle)
                            .frame(maxWidth: .infinity,  alignment: .center)
                        if !transactions.homeTotal.isNaN {
                            Text("$\(transactions.homeTotal, specifier: "%.2f") (\(1/transactions.averageForexPrice , specifier: "%.2f") ₽/$)")
                                .font(.title2)
                                .frame(maxWidth: .infinity,  alignment: .center)
                        }
                    }
                }
                
                Section(header: Text("Recent Transactions")) {
                    List {
                        ForEach(transactions.sortedByDate.prefix(5)) { transaction in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(transaction.title)
                                    Text(Formatter().shortDate(date: transaction.date))
                                }

                                Spacer()
                                Text("\(transaction.forexAmount, specifier: "%.2f")")
                                    .foregroundColor(transaction.forexAmount > 0 ? .green : .red)
                            }
                        }
                    }
                }
                
                Section(header: Text("Live Rate")) {
                        HStack {
                            Spacer()
                            Text("\(transactions.liveRate, specifier: "%.2f") ₽/$")
                            Text("\(transactions.rateChangePercenate > 0 ? "+" : "")\(transactions.rateChangePercenate, specifier: "%.2f")%")
                                .foregroundColor(transactions.rateChangePercenate > 0 ? .green : .red)
                            Spacer()
                            }
                            .font(.title3)
                }
            }
            .navigationBarTitle("Ruble 🇷🇺")
            .navigationBarItems(trailing: Button("Switch Currency") {
                showingActionSheet = true
            })
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(title: Text("Pick a pairing."), buttons: [
                    .default(Text("CAD to RUB")) { print("cad to rub") },
                    .default(Text("CAD to USD")) { print("cad to usd") },
                    .default(Text("New Pair")) { showingNewCurrency = true },
                    .cancel()
                ])
            }
            .sheet(isPresented: $showingNewCurrency, content: {
                NewCurrencyView()
//                    .environmentObject(transactions)
            })
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
