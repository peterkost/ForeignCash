//
//  CurrencyPairs.swift
//  ForeignCash
//
//  Created by Peter Kostin on 2021-06-18.
//

import Foundation

class CurrencyPairs {
    var availablePairs = [Symbol]()
    
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
                    self.availablePairs = Array(decodedResponse.symbols.values).sorted()
                }
            }
        }.resume()
    }
}
