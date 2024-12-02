//
//  CountryDto.swift
//  CurrencyConverter
//
//  Created by androiddev on 11/21/24.
//

struct CountryDto: Decodable {
    let name: NameDto
    let cca2: String
    let currencies: [String : CurrencyDto]
    
    enum CodingKeys: String, CodingKey {
        case name
        case cca2
        case currencies
    }
}

extension CountryDto {
    public func toDomainModel() -> Country {
        return Country(
            name: name.common,
            code: cca2.lowercased(),
            currency: Currency(
                name: currencies.first?.value.name ?? "",
                code: currencies.first?.key.lowercased() ?? ""
            )
        )
    }
}

struct NameDto: Decodable {
    let common: String
    let official: String
    let nativeName: [String : [String : String]]
    
    enum CodingKeys: String, CodingKey {
        case common
        case official
        case nativeName
    }
}
