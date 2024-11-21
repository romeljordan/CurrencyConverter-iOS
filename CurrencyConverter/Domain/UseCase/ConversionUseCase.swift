//
//  ConversionUseCase.swift
//  CurrencyConverter
//
//  Created by androiddev on 11/21/24.
//

protocol ConversionUseCase {
    func loadCurrentRates(baseCurrency: String) -> [Country]
}

class ConversionUseCaseImpl: ConversionUseCase {
    private let repository: ConversionRepository
    
    init(repository: ConversionRepository) {
        self.repository = repository
    }
    
    func loadCurrentRates(baseCurrency: String) -> [Country] {
        return repository.loadCurrentRates(baseCurrency: baseCurrency)
    }
}
