//
//  ConversionRepositoryImpl.swift
//  CurrencyConverter
//
//  Created by androiddev on 11/21/24.
//

import Alamofire
import RxSwift

final class ConversionRepositoryImpl : ConversionRepository {
    var dataSource: AppRemoteDataSourceImpl!
    
    init(dataSource: AppRemoteDataSourceImpl) {
        self.dataSource = dataSource
    }
    
    func loadCurrentRates(baseCurrency: String) -> Single<[String : Double]> {
        return Single.create { single in
            self.dataSource.loadCurrentRates(for: baseCurrency).subscribe(
                onSuccess: { item in
                    single(.success(item.rates))
                },
                onFailure: { error in
                    single(.failure(error))
                }
            )
        }
    }
}
