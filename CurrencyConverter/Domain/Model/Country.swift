//
//  Currency.swift
//  CurrencyConverter
//
//  Created by androiddev on 11/20/24.
//

struct Country: Hashable {
    static func == (lhs: Country, rhs: Country) -> Bool {
        return lhs.code == rhs.code && lhs.name == rhs.name && lhs.currency == rhs.currency
    }
    
    var name: String
    var code: String
    var currency: Currency
    
    init(name: String, code: String, currency: Currency) {
        self.name = name
        self.code = code
        self.currency = currency
    }
}
