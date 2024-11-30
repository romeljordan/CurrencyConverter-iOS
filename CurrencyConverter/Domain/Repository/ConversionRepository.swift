//
//  ConversionRepository.swift
//  CurrencyConverter
//
//  Created by androiddev on 11/21/24.
//

import RxSwift

protocol ConversionRepository {
    func loadCurrentRates(baseCurrency: String) -> Single<[String : Double]>
}
