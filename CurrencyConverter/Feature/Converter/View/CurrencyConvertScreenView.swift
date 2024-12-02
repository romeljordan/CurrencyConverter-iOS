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
            conversionUseCase:
                ConversionUseCaseImpl(
                    repository: ConversionRepositoryImpl(
                        dataSource: AppRemoteDataSourceImpl(
                            appService: AppService()
                        )
                    )
                ),
            countryUseCase: CountryUsecaseImpl(
                repository: CountryRepositoryImpl(
                    dataSource: AppRemoteDataSourceImpl(
                        appService: AppService()
                    )
                )
            )
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
            let selectedList = switch inputType {
            case .base:
                [viewModel.screenState.baseCountry]
            case .converted(let current):
                [current]
            case .new:
                viewModel.screenState.selectedCountryList.map({ $0.code })
            }
            
            SelectionCountryListScreenView(
                list: viewModel.screenState.countryList
                    .filter { item in
                        switch inputType {
                        case .base:
                            !viewModel.screenState.selectedCountryList.contains(item)
                        case .converted(let current):
                            viewModel.screenState.selectedCountryList
                                .filter({ current.lowercased() != $0.code.lowercased() })
                                .contains(where: {
                                    item.code.lowercased() != $0.code.lowercased() && item.code.lowercased() != viewModel.screenState.baseCountry.lowercased()
                                })
                        case .new:
                            item.code.lowercased() != viewModel.screenState.baseCountry.lowercased()
                        }
                    },
                initialSelected: selectedList,
                isMultiple: (inputType == .new),
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
