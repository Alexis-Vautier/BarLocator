//
//  CryptoMarket.swift
//  BarLocator
//
//  Created by Alexis Vautier on 26/11/2021.
//

import Foundation

struct GlobalMarket: Decodable {
    let data: CryptoMarket
    
    private enum CodingKeys: String, CodingKey {
        case data
    }
}
struct CryptoMarket: Decodable {
    let total_market_cap: [String: Double]
    let total_volume: [String: Double]
    let market_cap_percentage: [String: Double]
    let updated_at: Double

    private enum CodingKeys: String, CodingKey {
        case total_market_cap
        case market_cap_percentage
        case total_volume
        case updated_at
    }
}
