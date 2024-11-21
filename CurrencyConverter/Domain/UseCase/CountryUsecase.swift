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
        return Single.create { [weak self] single in
            self!.repository.loadCountries().subscribe(
                onSuccess: { items in
                    single(.success(items.map({ dto in
                        dto.toDomainModel()
                    })))
                },
                onFailure: { error in
                    single(.failure(error))
                }
            )
        }
    }
}
