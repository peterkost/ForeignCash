//
//  NewCurrencyView.swift
//  ForeignCash
//
//  Created by Peter Kostin on 2021-06-18.
//

import SwiftUI

struct NewCurrencyView: View {
    @Environment(\.presentationMode) var presentationMode
    
    
    let availableCurrencies = ["AUD", "CAD", "RUB", "USD"]
    @State private var fromCurrency = "AUD"
    @State private var toCurrency = "CAD"
    
    var body: some View {
        NavigationView {
        Form {
            Section(header: Text("From")) {
                Picker("From", selection: $fromCurrency) {
                    ForEach(availableCurrencies, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(WheelPickerStyle())
            }
            
            Section(header: Text("To")) {
                Picker("To", selection: $toCurrency) {
                    ForEach(availableCurrencies, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(WheelPickerStyle())
            }
        }
        .navigationBarTitle("New Currency Pairing")
        .navigationBarItems(leading: Button(action: {presentationMode.wrappedValue.dismiss()}) {
            Image(systemName: "xmark")
        },
        trailing:
            Button(action: {print("xd")}) {
                Image(systemName: "checkmark")
            })
        }

        
    }
}

struct NewCurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        NewCurrencyView()
    }
}
