//
//  CurrencyConvertScreenView.swift
//  CurrencyConverter
//
//  Created by androiddev on 11/18/24.
//

import SwiftUI

enum ConverterNavResult {
    case MoveBack
}

struct CurrencyConvertScreenView: View {
    @ObservedObject var viewModel: CurrencyConvertViewModel = CurrencyConvertViewModel(
        conversionUseCase: ConversionUseCaseImpl(repository: ConversionRepositoryImpl()),
        countryUseCase: CountryUsecaseImpl(repository: CountryRepositoryImpl())
    )
    
    @State var value: Double = 0
    @State var isCountryListPopupShown = false
    @State var inputType: InputType = .new
    
    var onNavResult: (_ result: ConverterNavResult) -> Void
    
    init(onNavResult: @escaping (_: ConverterNavResult) -> Void) {
        self.onNavResult = onNavResult
    }
    
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
                    countryCode: viewModel.screenState.baseCountry,
                    onUpdateValueListener: {
                        isCountryListPopupShown = true
                        inputType = .base
                    }
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
                            value: value * (viewModel.getConversionRate(for: item.currency.code)),
                            onDelete: {
                                viewModel.removeCountryFromSelection(code: item.code)
                            }
                        ).onTapGesture {
                            isCountryListPopupShown = true
                            inputType = .converted(current: item.code)
                        }
                        .swipeActions(edge: .trailing, content: {
                            Text("Delete")
                                .foregroundStyle(Color.red)
                        })
                    }
                }
            }
        }
        .padding()
        .background(Color.black)
        .sheet(isPresented: $isCountryListPopupShown, content: {
            let selectedItems = switch inputType {
            case .base:
                [viewModel.screenState.baseCountry]
            case .converted(let current):
                [current]
            case .new:
                viewModel.screenState.selectedCountryList.map({ $0.code })
            }
            
            let disabledItems = switch inputType {
            case .base:
                viewModel.screenState.selectedCountryList.map{ $0.code }
            case .converted(let current):
                viewModel.screenState.selectedCountryList
                    .filter { $0.code != current }
                    .map{ $0.code } + [viewModel.screenState.baseCountry]
            case .new:
                [viewModel.screenState.baseCountry]
            }
            
            SelectionCountryListScreenView(
                list: viewModel.screenState.countryList,
                initialSelected: selectedItems,
                isMultiple: (inputType == .new),
                disabledItems: disabledItems,
                onClose: {
                    isCountryListPopupShown = false
                },
                onResults: { result in
                    switch inputType {
                    case .base:
                        guard let code = result.first else { break }
                        viewModel.updateBaseCountry(code: code)
                    case .converted(let current):
                        guard let newCode = result.first else { break }
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
    CurrencyConvertScreenView(onNavResult: { _ in })
}
