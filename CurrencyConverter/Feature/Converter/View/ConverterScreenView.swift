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
            
            let baseCurrency = viewModel.getCurrency(code: viewModel.screenState.baseCountry)
            if (baseCurrency != nil) {
                BaseCurrencyRowView(
                    currency: baseCurrency!,
                    countryCode: viewModel.screenState.baseCountry
                ) { newValue in
                    value = newValue
                }
            }
            
            ScrollView(.vertical) {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.screenState.selectedCountryList, id: \.self) { item in
                        CurrencyRowView(
                            currency: item.currency,
                            countryCode: item.code,
                            value: value * (viewModel.getConversionRate(for: item.currency.code))
                        ).onTapGesture {
                            isCountryListPopupShown = true
                            inputType = .converted(current: item.code)
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
                [viewModel.screenState.baseCountry]
            case .converted(let current):
                [current]
            case .new:
                viewModel.screenState.selectedCountryList.map({ $0.code })
            }
            
            SearchListScreenView(
                list: viewModel.screenState.countryList,
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
                        viewModel.addCountryToSelection(countryList: result)
                    }

                    isCountryListPopupShown = false
                }
            )
                .presentationDetents([.fraction(1), .fraction(1)])
                .presentationDragIndicator(.hidden)
        })
    }
}

#Preview {
    ConverterScreenView()
}
