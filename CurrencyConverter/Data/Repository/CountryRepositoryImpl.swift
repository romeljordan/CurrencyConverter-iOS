//
//  CountryRepositoryImpl.swift
//  CurrencyConverter
//
//  Created by androiddev on 11/21/24.
//

import Alamofire
import RxSwift

final class CountryRepositoryImpl : CountryRepository {
    private let dataSource: AppRemoteDataSourceImpl = AppRemoteDataSourceImpl.shared
    
    func loadCountries() -> Single<[Country]> {
        return Single.create { single in
            self.dataSource.loadCountryList().subscribe(
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
