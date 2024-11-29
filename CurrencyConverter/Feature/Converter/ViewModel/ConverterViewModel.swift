//
//  ConverterViewModel.swift
//  CurrencyConverter
//
//  Created by androiddev on 11/21/24.
//

import Foundation
import RxSwift

extension ConverterScreenView {
    struct ConverterScreenViewState {
        var countryList: [Country] = []
        var latestRates: [String : Double] = [:]
        var selectedCountryList: [String] = []
        var baseCountry: String = "us"
        
        mutating func update(
            countryList: [Country]? = nil,
            latestRates: [String : Double]? = nil,
            selectedCountryList: [String]? = nil,
            baseCountry: String? = nil
        ) {
            if countryList != nil {
                self.countryList = countryList!
            }
        }
    }
    
    class ConverterViewModel: ObservableObject {
        @Published private(set) var countries: [Country] = []
        @Published private(set) var rates: [String: Double] = [:]
        @Published private(set) var countryConvertList: [String] = []
        @Published private(set) var baseCountry: String = "us"
        
        private let conversionUseCase: ConversionUseCase
        private let countryUseCase: CountryUsecase
        
        private let disposedBag = DisposeBag()

        init(conversionUseCase: ConversionUseCase, countryUseCase: CountryUsecase) {
            self.conversionUseCase = conversionUseCase
            self.countryUseCase = countryUseCase
            
            load()
        }
        
        func load() {
            countryUseCase.loadCountries().subscribe { event in
                switch event {
                case .success(let value):
                    self.countries = value
                    self.loadCurrentRates()
                case .failure(let error):
                    print("Error fetching list of countries: \(error)")
                }
            }
            .disposed(by: disposedBag)
        }
        
        func loadCurrentRates() {
            guard let baseCurrency = getCurrency(code: baseCountry) else { return }
            conversionUseCase
                .loadCurrentRates(baseCurrency: baseCurrency.code)
                .subscribe { event in
                    switch event {
                    case.success(let value):
                        self.rates = value
                        print("[DEBUG] rates: \(self.rates)")
                    case .failure(let error):
                        print("Error fetching of current rates: \(error)")
                    }
                }
                .disposed(by: disposedBag)
        }
        
        func getCurrency(code: String) -> Currency? {
            guard let country = getCountry(for: code) else { return nil }
            
            return country.currency
        }
        
        func addCountryFromConversion(countryList: [String]) {
            countryList.forEach { code in
                if (!countryConvertList.contains(code)) {
                    countryConvertList.append(code)
                }
            }
        }
        
        func removeCountryFromConversion(code: String) {
            countryConvertList.removeAll(where: { code == $0 })
        }
        
        func updateBaseCountry(code: String) {
            let refresh = (baseCountry != code)
            baseCountry = code
    
            if (refresh) {
                loadCurrentRates()
            }
        }
        
        func updateSelectedCountryToConvert(old: String, new: String) {
            guard let index = countryConvertList.firstIndex(where: { $0 == old }) else { return }
            
            countryConvertList[index] = new
        }
        
        func getConversionRate(for code: String) -> Double {
            return rates[code.uppercased()] ?? 0
        }
        
        private func getCountry(for code: String) -> Country? {
            return countries.filter({ $0.code.lowercased() == code.lowercased() }).first
        }
    }
    
    enum InputType: Equatable {
        case base
        case converted(current: String)
        case new
    }
}
