//
//  CountryRepositoryImpl.swift
//  CurrencyConverter
//
//  Created by androiddev on 11/21/24.
//

final class CountryRepositoryImpl : CountryRepository {
    
    func loadCountries() -> [Country] {
        return [
            Country(name: "Vietnam", code: "vn", currency: Currency(name: "Vietnam Dong", code: "vnd")),
            Country(name: "Philippines", code: "ph", currency: Currency(name: "Philippine Peso", code: "php")),
            Country(name: "USA", code: "us", currency: Currency(name: "US Dollar", code: "usd"))
        ]
        // TODO: add real data from rest country API
    }
}
