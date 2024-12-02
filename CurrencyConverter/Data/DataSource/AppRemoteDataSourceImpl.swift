//
//  AppRemoteDataSourceImpl.swift
//  CurrencyConverter
//
//  Created by androiddev on 12/2/24.
//

import Alamofire
import RxSwift

final class AppRemoteDataSourceImpl {
    static let shared = AppRemoteDataSourceImpl()
    private let appService: AppService = AppService.shared
    
    private init() { }
    
    func loadCountryList() -> Single<[CountryDto]> {
        return appService.getCountries()
    }
    
    func loadCurrentRates(for baseCurrency: String) -> Single<RatesDto> {
        return appService.getCurrentRates(for: baseCurrency)
    }
}
