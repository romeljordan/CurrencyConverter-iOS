//
//  CountryRepositoryImpl.swift
//  CurrencyConverter
//
//  Created by androiddev on 11/21/24.
//

import Alamofire
import RxSwift

final class CountryRepositoryImpl : CountryRepository {
    
    func loadCountries() -> Single<[CountryDto]> {
        return Single.create { single in
            let request = AF.request("https://restcountries.com/v3.1/all?fields=currencies,cca2")
                .validate()
                .responseDecodable(of: Array<CountryDto>.self) { response in
                    switch response.result {
                    case .success(let value):
                        single(.success(value))
                    case .failure(let error):
                        single(.failure(error))
                    }
                }
            return Disposables.create { request.cancel() }
        }
        
//        return Single.just([
//            Country(name: "Vietnam", code: "vn", currency: Currency(name: "Vietnam Dong", code: "vnd")),
//            Country(name: "Philippines", code: "ph", currency: Currency(name: "Philippine Peso", code: "php")),
//            Country(name: "USA", code: "us", currency: Currency(name: "US Dollar", code: "usd"))
//        ])
        // TODO: add real data from rest country API
    }
}
