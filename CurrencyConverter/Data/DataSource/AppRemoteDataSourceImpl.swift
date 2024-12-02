//
//  ConversionRemoteDataSourceImpl.swift
//  CurrencyConverter
//
//  Created by androiddev on 12/2/24.
//

import Alamofire
import RxSwift

final class AppRemoteDataSourceImpl {
    var appService: AppService!
    
    init(appService: AppService!) {
        self.appService = appService
    }
    
    func loadCountryList() -> Single<[CountryDto]> {
        return appService.getCountries()
    }
    
    func loadCurrentRates(for baseCurrency: String) -> Single<RatesDto> {
        return appService.getCurrentRates(for: baseCurrency)
    }
}
