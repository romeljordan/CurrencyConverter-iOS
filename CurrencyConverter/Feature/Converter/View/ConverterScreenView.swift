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
    @State var isCountryListPopupShown = false
    @State var inputType: InputType = .new
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Currency Convert")
                    .font(.system(size: 28, weight: .heavy))
                    .foregroundStyle(Color.white)
                    .padding()
                
                Spacer()
                
                Button {
                    isCountryListPopupShown = true
                    inputType = .new
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(Color.white)
                }
            }
            
            let baseCurrency = viewModel.getCurrency(code: viewModel.baseCountry)
            if (baseCurrency != nil) {
                BaseCurrencyRowView(
                    currency: baseCurrency!,
                    countryCode: viewModel.baseCountry
                ) { newValue in
                    value = newValue
                }
            }
            
            ScrollView(.vertical) {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.countryConvertList, id: \.self) { code in
                        guard let currency = viewModel.getCurrency(code: code) else { return }
                            CurrencyRowView(
                                currency: currency!,
                                countryCode: code,
                                value: value * (viewModel.getConversionRate(for: currency!.code))
                            ).onTapGesture {
                                isCountryListPopupShown = true
                                inputType = .converted(current: code)
                            }
                    }
                }
            }
        }
        .padding()
        .background(Color.black)
        .sheet(isPresented: $isCountryListPopupShown, content: {
            let selectedList = switch inputType {
            case .base:
                [viewModel.baseCountry]
            case .converted(let current):
                [current]
            case .new:
                viewModel.countryConvertList
            }
            
            SearchListScreenView(
                list: viewModel.countries,
                initialSelected: selectedList,
                isMultiple: (inputType == .new),
                onResults: { result in
                    switch inputType {
                    case .base:
                        guard let code = result.first else { return }
                        viewModel.updateBaseCountry(code: code)
                    case .converted(let current):
                        guard let newCode = result.first else { return }
                        viewModel.updateSelectedCountryToConvert(old: current, new: newCode)
                    case .new:
                        viewModel.addCountryFromConversion(countryList: result)
                    }

                    isCountryListPopupShown = false
                }
            )
                .presentationDetents([.fraction(1), .fraction(0.85)])
                .presentationDragIndicator(.hidden)
        })
    }
}

#Preview {
    ConverterScreenView()
}
