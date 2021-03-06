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


class CurrencyPair: ObservableObject, Codable {
    // Codable conformance
    enum CodingKeys: CodingKey {
        case from, to, id, items, liveRate
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(from, forKey: .from)
        try container.encode(to, forKey: .to)
        try container.encode(items, forKey: .items)
        try container.encode(id, forKey: .id)
        try container.encode(liveRate, forKey: .liveRate)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        from = try container.decode(String.self, forKey: .from)
        to = try container.decode(String.self, forKey: .to)
        id = try container.decode(String.self, forKey: .id)
        items = try container.decode([Transaction].self, forKey: .items)
        liveRate = try container.decode(Double.self, forKey: .liveRate)
    }
    
    
    let from: String
    let to: String
    let id: String
    
    @Published var items = [Transaction]()
    
    var liveRate: Double = 30
    
    var rateChangePercenate: Double {
        ((liveRate - (1/averageForexPrice)) / (1/averageForexPrice)) * 100
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
    
    var groupedByDate: [[Transaction]] {
        var result = [[Transaction]]()
        guard sortedByDate.count > 0 else {return result}
        
        result[0].append(sortedByDate[0])
        var resultIndex = 0
        
        for i in 1..<sortedByDate.count {
            if result[resultIndex][0].date == sortedByDate[i].date {
                result[resultIndex].append(sortedByDate[i])
            } else {
                resultIndex += 1
                result.append([sortedByDate[i]])
            }
        }
        return result
    }
    

    var averageForexPrice: Double {
        var curForexTotal: Double = 0
        var curWeightedTotal: Double = 0
        
        for item in sortedByDate where item.type == "Add" {
            if curForexTotal > forexTotal { break }
            
            let priceForForex = item.homeAmount / item.forexAmount
            let weightedPriceForForex = priceForForex * item.forexAmount
            curForexTotal += item.forexAmount
            curWeightedTotal += weightedPriceForForex
        }
        return curWeightedTotal / curForexTotal
    }
    
    
    init(from: String, to: String) {
        self.from = from
        self.to = to
        self.id = "\(from)-\(to)"
        
    }
    
    func addTransaction(title: String, descirption: String, type: String, forexAmount: Double, homeAmount: Double = 0) {
        var calulatedHomeAmount: Double = homeAmount
        var calculatedForexAmount: Double = forexAmount
        if type == "Spend" {
            calulatedHomeAmount = -(forexAmount * averageForexPrice)
            calculatedForexAmount = -calculatedForexAmount
        }
        let newTransaction = Transaction(id: UUID(), date: Date(), title: title, description: descirption, type: type, forexAmount: calculatedForexAmount, homeAmount: calulatedHomeAmount)
        items.append(newTransaction)
    }
    
    func deleteTransactionWithID(_ id: UUID) {
        if let target = items.firstIndex(where: { $0.id == id }) {
            items.remove(at: target)
        } else {
            print("traget not found")
        }
    }
    
    func getLiveRate() {
        // Generate Request
        let url = URL(string: "https://api.exchangerate.host/convert?from=\(from)&to=\(to)")!
        let request = URLRequest(url: url)

        // Send Request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                // Process Responce
                if let decodedResponse = try? JSONDecoder().decode(liveRateJSON.self, from: data) {
                    self.liveRate = decodedResponse.result
                }
            }
        }.resume()
    }
}
