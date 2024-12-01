//
//  Extension+List.swift
//  CurrencyConverter
//
//  Created by androiddev on 11/29/24.
//

extension Array where Element: Any {
    public func copy() -> Array<Element> {
        var copiedArray = Array<Element>()
        for element in self {
            copiedArray.append(element)
        }
        return copiedArray
    }
}
