//
//  CountryRepository.swift
//  CurrencyConverter
//
//  Created by androiddev on 11/21/24.
//

import RxSwift

protocol CountryRepository {
    func loadCountries() -> Single<[CountryDto]>
}
