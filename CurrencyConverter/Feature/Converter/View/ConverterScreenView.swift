//
//  ContentView.swift
//  CurrencyConverter
//
//  Created by androiddev on 11/18/24.
//

import SwiftUI

struct ConverterScreenView: View {
    @ObservedObject var viewModel: ConverterViewModel = ConverterViewModel(conversionUseCase: ConversionUseCaseImpl(repository: ConversionRepositoryImpl()), countryUseCase: CountryUsecaseImpl(repository: CountryRepositoryImpl()))
    
    @State var value: Double = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Currency Convert")
                    .font(.system(size: 28, weight: .heavy))
                    .foregroundStyle(Color.white)
                    .padding()
                
                Spacer()
                
                Button {
                    // TODO: add click functionality
                    guard let code = ["ph", "vn"].randomElement() else { return }
                    viewModel.addCountryFromConversion(code: code)
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(Color.white)
                }
            }
            
            let baseCurrency = viewModel.getCurrency(code: viewModel.baseCountry)
            if (baseCurrency != nil) {
                BaseCurrencyRowView(currency: baseCurrency!, countryCode: viewModel.baseCountry) { newValue in
                    value = newValue
                }
            }
            
            ScrollView(.vertical) {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.countryConvertList, id: \.self) { code in
                        let currency = viewModel.getCurrency(code: code)
                        if (currency != nil) {
                            CurrencyRowView(currency: currency!, countryCode: code, value: value * (viewModel.rates[currency!.code] ?? 0))
                        }
                    }
                }
            }
            
        }
        .padding()
        .background(Color.black)
    }
}

#Preview {
    ConverterScreenView()
}
