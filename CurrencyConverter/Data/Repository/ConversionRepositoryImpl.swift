//
//  ConversionRepositoryImpl.swift
//  CurrencyConverter
//
//  Created by androiddev on 11/21/24.
//

final class ConversionRepositoryImpl : ConversionRepository {
    func loadCurrentRates(baseCurrency: String) -> [String : Double] {
        return ["vnd": 25341.081325824, "php": 58.86849795]
        // TODO: add real data from api
    }
}
