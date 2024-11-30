//
//  CurrencyRowView.swift
//  CurrencyConverter
//
//  Created by androiddev on 11/18/24.
//

import SwiftUI

struct CurrencyRowView: View {
    var currency: Currency
    var countryCode: String
    var value: Double
    
    init(currency: Currency, countryCode: String, value: Double) {
        self.currency = currency
        self.countryCode = countryCode
        self.value = value
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("CONVERT TO")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.white)
                Spacer()
            }
            
            Spacer().frame(height: 8)
            
            Spacer()
                .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 0.5)
                .background(Color.gray)
            
            Spacer().frame(height: 8)
            
            HStack {
                Spacer()
                AsyncImage(url: URL(string: "https://flagsapi.com/\(countryCode.uppercased())/flat/32.png"))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16, height: 16)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8))
                Text(currency.name)
                    .font(.system(size: 16, weight: .light))
                    .foregroundStyle(.gray)
                
                Image("arrowDropDown")
                    .foregroundStyle(.tint)
            }
            
            HStack(alignment: .lastTextBaseline) {
                Spacer()
                Text(currency.code.uppercased())
                    .font(.callout)
                    .foregroundStyle(.gray)
                Text(value.formatToString())
                    .font(.system(size: 35, weight: .medium))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
            }
        }
        .padding(16)
    }
}

#Preview {
    HStack {
        CurrencyRowView(currency: Currency(name: "US Dollar", code: "usd"), countryCode: "us", value: 25)
    }
    .background(Color.black)
}
