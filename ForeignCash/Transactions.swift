//
//  Transactions.swift
//  ForeignCash
//
//  Created by Peter Kostin on 2021-06-17.
//

import Foundation

struct Transaction: Identifiable, Codable {
    let id: UUID
    let date: Date
    
    var title: String
    var description: String
    var type: String
    var forexAmount: Double
    var homeAmount: Double
}


class Transactions: ObservableObject {
    static let fileKey = "transactions"
    
    @Published var items = [Transaction]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: Transactions.fileKey)
            }
        }
    }
    
    var forexTotal: Double {
        var count: Double = 0
        for item in items {
            count += item.forexAmount
        }
        return count
    }
    
    var homeTotal: Double {
        return forexTotal * averageForexPrice
    }
    
    var sortedByDate: [Transaction] {
        return items.sorted(by: { $0.date > $1.date })
    }
    

    var averageForexPrice: Double {
        var curForexTotal: Double = 0
        var curWeightedTotal: Double = 0
        
        for item in sortedByDate where item.type == "Add" {
            print(curForexTotal, forexTotal)
            if curForexTotal > forexTotal { break }
            
            let priceForForex = item.homeAmount / item.forexAmount
            let weightedPriceForForex = priceForForex * item.forexAmount
            curForexTotal += item.forexAmount
            curWeightedTotal += weightedPriceForForex
        }
        return curWeightedTotal / curForexTotal
    }
    
    
    init() {
        if let items = UserDefaults.standard.data(forKey: Transactions.fileKey) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Transaction].self, from: items) {
                self.items = decoded
                return
            }
        }
        items = []
    }
    
    func addTransaction(title: String, descirption: String, type: String, forexAmount: Double, homeAmount: Double = 0) {
        var calulatedHomeAmount: Double = homeAmount
        var calculatedForexAmount: Double = forexAmount
        if type == "Spend" {
            calulatedHomeAmount = forexAmount * averageForexPrice
            calculatedForexAmount = -calculatedForexAmount
        }
        let newTransaction = Transaction(id: UUID(), date: Date(), title: title, description: descirption, type: type, forexAmount: calculatedForexAmount, homeAmount: calulatedHomeAmount)
        items.append(newTransaction)
    }
}
