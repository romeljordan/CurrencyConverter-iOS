//
//  CurrencyDto.swift
//  CurrencyConverter
//
//  Created by androiddev on 11/21/24.
//

struct CurrencyDto: Decodable {
    let name: String
    let symbol: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case symbol
    }
}
