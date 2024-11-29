//
//  ConversionRepositoryImpl.swift
//  CurrencyConverter
//
//  Created by androiddev on 11/21/24.
//

import Alamofire
import RxSwift

final class ConversionRepositoryImpl : ConversionRepository {
    func loadCurrentRates(baseCurrency: String) -> Single<[String : Double]> {
        return Single.create { single in
            
            let headers: HTTPHeaders = [.authorization(bearerToken: "fxr_live_c54bd208277d0cbcfad867df77d9b2c259a3")]
            let request = AF.request("https://api.fxratesapi.com/latest", method: .get, headers: headers)
                .validate()
                .responseDecodable(of: RatesDto.self) { response in
                    switch response.result {
                    case .success(let value):
                        single(.success(value.rates))
                    case .failure(let error):
                        single(.failure(error))
                    }
                }
            
            return Disposables.create { request.cancel() }
        }
    }
}
