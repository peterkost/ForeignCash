//
//  ContentView.swift
//  ForeignCash
//
//  Created by Peter Kostin on 2021-06-17.
//

import SwiftUI

struct ContentView: View {
    var currencyPairs = CurrencyPairs()
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            TransactionsListView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Transactions")
                }
        }
        .environmentObject(currencyPairs)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
