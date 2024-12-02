//
//  ConversionUseCase.swift
//  CurrencyConverter
//
//  Created by androiddev on 11/21/24.
//

import RxSwift

protocol ConversionUseCase {
    func loadCurrentRates(baseCurrency: String) -> Single<[String : Double]>
}

class ConversionUseCaseImpl: ConversionUseCase {
    private let repository: ConversionRepository
    
    init(repository: ConversionRepository) {
        self.repository = repository
    }
    
    func loadCurrentRates(baseCurrency: String) -> Single<[String : Double]> {
        return repository.loadCurrentRates(baseCurrency: baseCurrency) // TODO: add do-catch statement
    }
}
