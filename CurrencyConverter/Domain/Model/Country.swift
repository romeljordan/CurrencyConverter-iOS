//
//  Currency.swift
//  CurrencyConverter
//
//  Created by androiddev on 11/20/24.
//

struct Country {
    var name: String
    var code: String
    var currency: Currency
    
    init(name: String, code: String, currency: Currency) {
        self.name = name
        self.code = code
        self.currency = currency
    }
}
