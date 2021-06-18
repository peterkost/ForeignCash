//
//  NewCurrencyView.swift
//  ForeignCash
//
//  Created by Peter Kostin on 2021-06-18.
//

import SwiftUI

struct NewCurrencyView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var availableCurrencies = [Symbol]()
    
    
//    let availableCurrencies = ["AUD", "CAD", "RUB", "USD"]
    @State private var fromCurrency = "AUD"
    @State private var toCurrency = "CAD"
    
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
        .navigationBarItems(leading: Button(action: {presentationMode.wrappedValue.dismiss()}) {
            Image(systemName: "xmark")
        },
        trailing:
            Button(action: {print("xd")}) {
                Image(systemName: "checkmark")
            })
        }
        .onAppear(perform: getAvailablePairs)
    }
    
    func getAvailablePairs() {
        // Generate Request
        let url = URL(string: "https://api.exchangerate.host/symbols")!
        let request = URLRequest(url: url)

        // Send Request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                // Process Responce
                if let decodedResponse = try? JSONDecoder().decode(availableCurrenciesJSON.self, from: data) {
                    self.availableCurrencies = Array(decodedResponse.symbols.values).sorted()
                }
            }
        }.resume()
    }
}

struct NewCurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        NewCurrencyView()
    }
}
