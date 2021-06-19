//
//  CurrencyPairs.swift
//  ForeignCash
//
//  Created by Peter Kostin on 2021-06-18.
//

import Foundation

class CurrencyPairs: ObservableObject {
    var availableCurrencies = [Symbol]()
    @Published var currencyPairs = [CurrencyPair]()
    
    var selectedPairID: String?
    
    var selectedPair: CurrencyPair? {
        for pair in currencyPairs where pair.id == selectedPairID {
            return pair
        }
        return nil
    }
    
    var currencyPairsIDs: [String] {
        var res = [String]()
        for pair in currencyPairs {
            res.append(pair.id)
        }
        return res
    }
    
    init() {
        getAvailablePairs()
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
    
    func addPair(from: String, to: String) {
        let newPair = CurrencyPair(from: from, to: to)
        currencyPairs.append(newPair)
        selectPair(id: newPair.id)
    } 
    
    func selectPair(id: String) {
        selectedPairID = id
    }
}
