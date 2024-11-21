//
//  ConversionRepositoryImpl.swift
//  CurrencyConverter
//
//  Created by androiddev on 11/21/24.
//

import Alamofire

final class ConversionRepositoryImpl : ConversionRepository {
    func loadCurrentRates(baseCurrency: String) -> [String : Double] {
        
//        let headers: HTTPHeaders = [.authorization(bearerToken: "fxr_live_c54bd208277d0cbcfad867df77d9b2c259a3")]
//        let responses = await AF.request("https://api.fxratesapi.com/latest", method: .get, headers: headers)
//            .response { response in
//                print("[DEBUG:url] \(response)")
//            }
        
//        let responses = await AF.request("https://restcountries.com/v3.1/all", method: .get)
//            .response { response in
//                print("[DEBUG:url] \(response)")
//            }
        
        return ["vnd": 25341.081325824, "php": 58.86849795]
        // TODO: add real data from api
    }
}
