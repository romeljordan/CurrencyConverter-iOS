//
//  CountryUsecase.swift
//  CurrencyConverter
//
//  Created by androiddev on 11/21/24.
//

protocol CountryUsecase {
    func loadCountries() -> [Country]
}

class CountryUsecaseImpl : CountryUsecase {
    private let repository: CountryRepository
    
    init(repository: CountryRepository) {
        self.repository = repository
    }
    
    func loadCountries() -> [Country] {
        return repository.loadCountries()
    }
}
