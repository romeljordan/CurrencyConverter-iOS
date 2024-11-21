//
//  ConversionRepository.swift
//  CurrencyConverter
//
//  Created by androiddev on 11/21/24.
//

protocol ConversionRepository {
    func loadCurrentRates(baseCurrency: String) -> [String : Double]
}
