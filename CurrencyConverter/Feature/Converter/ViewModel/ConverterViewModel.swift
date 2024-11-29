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
        var baseCountry: String = ""
        
        mutating func update(
            countryList: [Country]? = nil,
            latestRates: [String : Double]? = nil,
            selectedCountryList: [String]? = nil,
            baseCountry: String? = nil
        ) {
            if countryList != nil {
                self.countryList = countryList!
            }
            
            if latestRates != nil {
                self.latestRates = latestRates!
            }
            
            if selectedCountryList != nil {
                self.selectedCountryList = selectedCountryList!
            }
            
            if baseCountry != nil {
                self.baseCountry = baseCountry!
            }
        }
    }
    
    class ConverterViewModel: ObservableObject {
//        @Published private(set) var countries: [Country] = []
//        @Published private(set) var rates: [String: Double] = [:]
//        @Published private(set) var countryConvertList: [String] = []
//        @Published private(set) var baseCountry: String = "us"
        
        @Published private(set) var screenState: ConverterScreenViewState = ConverterScreenViewState(baseCountry: "us")
        
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
//                    self.countries = value
                    self.screenState.update(countryList: value)
                    self.loadCurrentRates()
                case .failure(let error):
                    print("Error fetching list of countries: \(error)")
                }
            }
            .disposed(by: disposedBag)
        }
        
        func loadCurrentRates() {
            guard let baseCurrency = getCurrency(code: screenState.baseCountry) else { return }
            conversionUseCase
                .loadCurrentRates(baseCurrency: baseCurrency.code)
                .subscribe { event in
                    switch event {
                    case.success(let value):
                        self.screenState.update(latestRates: value)
//                        self.rates = value
//                        print("[DEBUG] rates: \(self.rates)")
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
                if (!screenState.selectedCountryList.contains(code)) {
//                    countryConvertList.append(code)
                    var copy = screenState.selectedCountryList.map { $0 }
                    copy.append(code)
                    screenState.update(selectedCountryList: copy)
                }
            }
        }
        
        func removeCountryFromConversion(code: String) {
            var copy = screenState.selectedCountryList.map { $0 }
            copy.removeAll(where: { code == $0 })
                
            screenState.update(selectedCountryList: copy)
        }
        
        func updateBaseCountry(code: String) {
            let refresh = (screenState.baseCountry != code)
            screenState.update(baseCountry: code)
    
            if (refresh) {
                loadCurrentRates()
            }
        }
        
        func updateSelectedCountryToConvert(old: String, new: String) {
            guard let index = screenState.selectedCountryList.firstIndex(where: { $0 == old }) else { return }
            
            var copy = screenState.selectedCountryList.map { $0 }
            copy[index] = new
            
            screenState.update(selectedCountryList: copy)
        }
        
        func getConversionRate(for code: String) -> Double {
            return screenState.latestRates[code.uppercased()] ?? 0
        }
        
        private func getCountry(for code: String) -> Country? {
            return screenState.countryList.filter({ $0.code.lowercased() == code.lowercased() }).first
        }
    }
    
    enum InputType: Equatable {
        case base
        case converted(current: String)
        case new
    }
}
