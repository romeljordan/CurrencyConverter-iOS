//
//  ConversionUseCase.swift
//  CurrencyConverter
//
//  Created by androiddev on 11/21/24.
//

protocol ConversionUseCase {
    func loadCurrentRates(baseCurrency: String) -> [String : Double]
}

class ConversionUseCaseImpl: ConversionUseCase {
    private let repository: ConversionRepository
    
    init(repository: ConversionRepository) {
        self.repository = repository
    }
    
    func loadCurrentRates(baseCurrency: String) -> [String : Double] {
        return repository.loadCurrentRates(baseCurrency: baseCurrency)
    }
}
