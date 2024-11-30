//
//  Currency.swift
//  CurrencyConverter
//
//  Created by androiddev on 11/20/24.
//

struct Currency: Hashable {
    var name: String
    var code: String
    
    init(name: String, code: String) {
        self.name = name
        self.code = code
    }
}
