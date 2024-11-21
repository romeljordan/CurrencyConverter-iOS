//
//  ConversionRepositoryImpl.swift
//  CurrencyConverter
//
//  Created by androiddev on 11/21/24.
//

class ConversionRepositoryImpl : ConversionRepository {
    func loadCurrentRates(baseCurrency: String) -> [Country] {
        return [
            Country(name: "Vietnam", code: "vn", currency: Currency(name: "Vietnam Dong", code: "vnd")),
            Country(name: "Philippines", code: "ph", currency: Currency(name: "Philippine Peso", code: "php")),
            Country(name: "USA", code: "us", currency: Currency(name: "US Dollar", code: "usd"))
        ]
        // TODO: add real data from api
    }
}
