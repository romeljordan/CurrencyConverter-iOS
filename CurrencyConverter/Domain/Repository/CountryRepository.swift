//
//  CountryRepository.swift
//  CurrencyConverter
//
//  Created by androiddev on 11/21/24.
//

protocol CountryRepository {
    func loadCountries() -> [Country]
}
