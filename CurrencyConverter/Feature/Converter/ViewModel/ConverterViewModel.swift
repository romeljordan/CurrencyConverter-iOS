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
        
        private let conversionUseCase: ConversionUseCase
        private let countryUseCase: CountryUsecase

        init(conversionUseCase: ConversionUseCase, countryUseCase: CountryUsecase) {
            self.conversionUseCase = conversionUseCase
            self.countryUseCase = countryUseCase
            
            load()
        }
        
        func load() {
            countries = countryUseCase.loadCountries()
            
            loadCurrentRates()
        }
        
        func loadCurrentRates() {
            guard let baseCurrency = getCurrency(code: baseCountry) else { return }
            rates = conversionUseCase.loadCurrentRates(baseCurrency: baseCurrency.code)
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
