//
//  RatesDto.swift
//  CurrencyConverter
//
//  Created by androiddev on 11/29/24.
//

struct RatesDto: Decodable {
    let success: Bool
    let terms: String
    let privacy: String
    let timestamp: Double
    let date: String
    let base: String
    let rates: [String : Double]
    
    enum CodingKeys: String, CodingKey {
        case success
        case terms
        case privacy
        case timestamp
        case date
        case base
        case rates
    }
}
