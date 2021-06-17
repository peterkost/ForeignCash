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
    

    var averageForexPrice: Double = 0.017
    
    
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
        if type == "Spend" {
            calulatedHomeAmount = forexAmount * averageForexPrice
        }
        let newTransaction = Transaction(id: UUID(), date: Date(), title: title, description: descirption, type: type, forexAmount: forexAmount, homeAmount: calulatedHomeAmount)
        items.append(newTransaction)
    }
}
