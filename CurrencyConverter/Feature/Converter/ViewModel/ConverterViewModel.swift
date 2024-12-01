//
//  ConverterViewModel.swift
//  CurrencyConverter
//
//  Created by androiddev on 11/21/24.
//

import Foundation
import RxSwift

extension CurrencyConvertScreenView {
    struct ConverterScreenViewState {
        var countryList: [Country] = []
        var latestRates: [String : Double] = [:]
        var selectedCountryList: [Country] = []
        var baseCountry: String = ""
        
        mutating func update(
            countryList: [Country]? = nil,
            latestRates: [String : Double]? = nil,
            baseCountry: String? = nil
        ) {
            if countryList != nil {
                self.countryList = countryList!
            }
            
            if latestRates != nil {
                self.latestRates = latestRates!
            }
            
            if baseCountry != nil {
                self.baseCountry = baseCountry!
            }
        }
        
        mutating func addToSelectedCountry(code: String) {
            countryList
                .filter( { $0.code.lowercased() == code.lowercased() } )
                .forEach { item in
                    if (!selectedCountryList.contains(item)) {
                        selectedCountryList.append(item)
                    }
                }
        }
        
        mutating func removeToSelectedCountry(code: String) {
            selectedCountryList.removeAll(where: { $0.code.lowercased() == code.lowercased() })
        }
        
        mutating func updateSelected(oldCode: String, newCode: String) {
            guard let selectedIndex = selectedCountryList
                .firstIndex(where: { $0.code.lowercased() == oldCode.lowercased() }) else { return }
            
            guard let newCountry = countryList
                .filter({ $0.code.lowercased() == newCode.lowercased() })
                .first else { return }
            
            selectedCountryList[selectedIndex] = newCountry
        }
    }
    
    class ConverterViewModel: ObservableObject {
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
        
        func addCountryToSelection(countryList: [String]) {
            countryList.forEach { code in
                screenState.addToSelectedCountry(code: code)
            }
        }
        
        func removeCountryFromSelection(code: String) {
            screenState.removeToSelectedCountry(code: code)
        }
        
        func updateBaseCountry(code: String) {
            let refresh = (screenState.baseCountry != code)
            screenState.update(baseCountry: code)
    
            if (refresh) {
                loadCurrentRates()
            }
        }
        
        func updateSelectedCountryToConvert(old: String, new: String) {
            screenState.updateSelected(oldCode: old, newCode: new)
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
