//
//  HomeWithTransactionsView.swift
//  ForeignCash
//
//  Created by Peter Kostin on 2021-06-19.
//

import SwiftUI

struct HomeWithTransactionsView: View {
    @EnvironmentObject var currencyPairs: CurrencyPairs
    @State private var showingActionSheet = false
    @State private var showingNewCurrency = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Current Balance")) {
                    VStack {
                        Text("\( currencyPairs.selectedPair!.forexTotal, specifier: "%.2f")₽")
                            .font(.largeTitle)
                            .frame(maxWidth: .infinity,  alignment: .center)
                        if !currencyPairs.selectedPair!.homeTotal.isNaN {
                            Text("$\(currencyPairs.selectedPair!.homeTotal, specifier: "%.2f") (\(1/currencyPairs.selectedPair!.averageForexPrice , specifier: "%.2f") ₽/$)")
                                .font(.title2)
                                .frame(maxWidth: .infinity,  alignment: .center)
                        }
                    }
                }
                
                Section(header: Text("Recent Transactions")) {
                    List {
                        ForEach( currencyPairs.selectedPair!.sortedByDate.prefix(5)) { transaction in
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
                            Text("\( currencyPairs.selectedPair!.liveRate, specifier: "%.2f") ₽/$")
                            Text("\( currencyPairs.selectedPair!.rateChangePercenate > 0 ? "+" : "")\( currencyPairs.selectedPair!.rateChangePercenate, specifier: "%.2f")%")
                                .foregroundColor( currencyPairs.selectedPair!.rateChangePercenate > 0 ? .green : .red)
                            Spacer()
                            }
                            .font(.title3)
                }
            }
            .navigationBarTitle( currencyPairs.selectedPair!.id)
            .navigationBarItems(trailing: Button("Switch Currency") {
                showingActionSheet = true
            })
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(title: Text("Pick a pairing."), buttons: makeActionSheetButtons())
            }
            .sheet(isPresented: $showingNewCurrency, content: {
                NewCurrencyView()
                    .environmentObject( currencyPairs.selectedPair!)
            })
        }
    }
    
    func makeActionSheetButtons() -> [Alert.Button] {
        var res = [Alert.Button]()
        
        for id in currencyPairs.currencyPairsIDs {
            res.append(Alert.Button.default(Text(id)) {
                currencyPairs.objectWillChange.send()
                        currencyPairs.selectPair(id: id)
                    
                
            })
        }
        
        res.append(Alert.Button.default(Text("New Pair")) { showingNewCurrency = true })
        res.append(Alert.Button.cancel())
        return res
    }
}

//struct HomeWithTransactionsView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeWithTransactionsView()
//    }
//}
