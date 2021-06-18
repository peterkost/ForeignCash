//
//  jsonResponce.swift
//  ForeignCash
//
//  Created by Peter Kostin on 2021-06-18.
//

import Foundation

struct jsonResponce: Codable {
    let motd: MOTD
    let success: Bool
    let query: Query
    let info: Info
    let historical: Bool
    let date: String
    let result: Double
}

struct Info: Codable {
    let rate: Double
}

struct MOTD: Codable {
    let msg: String
    let url: String
}

struct Query: Codable {
    let from, to: String
    let amount: Int
}
