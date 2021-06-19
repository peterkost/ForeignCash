//
//  HomeView.swift
//  ForeignCash
//
//  Created by Peter Kostin on 2021-06-17.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var currencyPairs: CurrencyPairs
    @State private var showingNewCurrency = false

    
    var body: some View {
        if currencyPairs.selectedPair == nil {
            NavigationView {
                VStack {
                    Button("Add New Currency") {
                        showingNewCurrency = true
                    }
                }
            }
            .sheet(isPresented: $showingNewCurrency, content: {
                NewCurrencyView()
                    .environmentObject(currencyPairs)
            })
        } else {
            HomeWithTransactionsView()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
