//
//  AppService.swift
//  CurrencyConverter
//
//  Created by androiddev on 12/2/24.
//

import Alamofire
import RxSwift

final class AppService {
    static let shared = AppService()
    
    private init() { }
    
    func getCountries() -> Single<[CountryDto]> {
        return Single.create { single in
            let url = "\(AppConfig.REST_API_BASE_URL)/all"
            let parameters: Parameters = ["fields" : "name,currencies,cca2"]
            let request = AF.request(url, method: .get, parameters: parameters)
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
    }
    
    func getCurrentRates(for baseCurrency: String) -> Single<RatesDto> {
        return Single.create { single in
            
            let headers: HTTPHeaders = [.authorization(bearerToken: "fxr_live_c54bd208277d0cbcfad867df77d9b2c259a3")] // TODO: transfer to plist or keychain
            let parameters: Parameters = ["base" : baseCurrency.uppercased()]
            let url = "\(AppConfig.FXRATES_API_BASE_URL)/latest"
            let request = AF.request(url, method: .get, parameters: parameters, headers: headers)
                .validate()
                .responseDecodable(of: RatesDto.self) { response in
                    switch response.result {
                    case .success(let value):
                        single(.success(value))
                    case .failure(let error):
                        single(.failure(error))
                    }
                }
            
            return Disposables.create { request.cancel() }
        }
    }
}
