//
//  CountryDto.swift
//  CurrencyConverter
//
//  Created by androiddev on 11/21/24.
//

struct CountryDto: Decodable {
    let cca2: String
    let currencies: [String : CurrencyDto]
    
    enum CodingKeys: String, CodingKey {
        case cca2
        case currencies
    }
}

extension CountryDto {
    public func toDomainModel() -> Country {
        return Country(
            name: "",
            code: cca2,
            currency: Currency(
                name: currencies.first?.value.name ?? "",
                code: currencies.first?.key ?? ""
            )
        )
    }
}
