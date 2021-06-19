//
//  NewCurrencyView.swift
//  ForeignCash
//
//  Created by Peter Kostin on 2021-06-18.
//

import SwiftUI

struct NewCurrencyView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var currencyPairs: CurrencyPairs
    @State private var availableCurrencies = [Symbol]()
    
    @State private var fromCurrency = "CAD"
    @State private var toCurrency = "USD"
    
    var body: some View {
        NavigationView {
        Form {
            Section(header: Text("From")) {
                Picker("From", selection: $fromCurrency) {
                    ForEach(availableCurrencies, id: \.self.code) { currency in
                        Text(currency.code + " - " + currency.symbolDescription)
                    }
                }
                .pickerStyle(WheelPickerStyle())
            }
            
            Section(header: Text("To")) {
                Picker("To", selection: $toCurrency) {
                    ForEach(availableCurrencies, id: \.self.code) { currency in
                        Text(currency.code + " - " + currency.symbolDescription)
                        
                    }
                }
                .pickerStyle(WheelPickerStyle())
            }
        }
        .navigationBarTitle("New Currency Pairing")
        .navigationBarItems(leading: Button(action: { presentationMode.wrappedValue.dismiss() }) {
            Image(systemName: "xmark")
        },
        trailing:
            Button(action: {
                    currencyPairs.addPair(from: fromCurrency, to: toCurrency)
                    presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "checkmark")
            })
        }
        .onAppear(perform: { availableCurrencies = currencyPairs.availableCurrencies })
    }
}

struct NewCurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        NewCurrencyView()
    }
}
