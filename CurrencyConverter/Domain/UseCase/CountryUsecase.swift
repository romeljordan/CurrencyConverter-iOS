//
//  CountryUsecase.swift
//  CurrencyConverter
//
//  Created by androiddev on 11/21/24.
//

import RxSwift

protocol CountryUsecase {
    func loadCountries() -> Single<[Country]>
}

class CountryUsecaseImpl : CountryUsecase {
    private let repository: CountryRepository
    
    init(repository: CountryRepository) {
        self.repository = repository
    }
    
    func loadCountries() -> Single<[Country]> {
        return repository.loadCountries() // TODO: add do-catch statement
    }
}
