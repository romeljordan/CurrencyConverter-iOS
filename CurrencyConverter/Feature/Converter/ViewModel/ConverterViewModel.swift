//
//  ConverterViewModel.swift
//  CurrencyConverter
//
//  Created by androiddev on 11/21/24.
//

import Foundation

extension ConverterScreenView {
    class ConverterViewModel: ObservableObject {
        @Published private(set) var countries: [Country] = []
        @Published private(set) var rates: [String: Double] = [:]
        @Published private(set) var countryConvertList: [String] = []
        @Published private(set) var baseCountry: String = "us"

        init() {
            load()
        }
        
        func load() {
            countries = [
                Country(name: "Vietnam", code: "vn", currency: Currency(name: "Vietnam Dong", code: "vnd")),
                Country(name: "Philippines", code: "ph", currency: Currency(name: "Philippine Peso", code: "php")),
                Country(name: "USA", code: "us", currency: Currency(name: "US Dollar", code: "usd"))
            ]
            
            loadCurrentRates()
        }
        
        func loadCurrentRates() {
            // TODO: use baseCurrency value for api call
            rates = ["vnd": 25341.081325824, "php": 58.86849795]
        }
        
        func getCurrency(code: String) -> Currency? {
            return countries
                .filter({ $0.code == code })
                .map({ $0.currency })
                .first
        }
        
        func addCountryFromConversion(code: String) {
            if (!countryConvertList.contains(code)) {
                countryConvertList.append(code)
            }
        }
        
        func removeCountryFromConversion(code: String) {
            countryConvertList.removeAll(where: { code == $0 })
        }
    }
}
