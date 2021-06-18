//
//  Formatter.swift
//  ForeignCash
//
//  Created by Peter Kostin on 2021-06-18.
//

import Foundation

struct Formatter {
    func shortDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    func shortDateTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
