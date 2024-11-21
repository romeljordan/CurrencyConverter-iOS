//
//  Extension+Double.swift
//  CurrencyConverter
//
//  Created by androiddev on 11/21/24.
//

import Foundation

extension Double {
    public func formatToString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}
