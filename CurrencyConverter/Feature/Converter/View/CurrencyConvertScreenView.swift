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
    @State var countryListInputType: InputType? = nil
    
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
                    countryListInputType = .new
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
                        countryListInputType = .base
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
                            countryListInputType = .converted(current: item.code)
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
            let selectedItems = switch countryListInputType {
            case .base: [viewModel.screenState.baseCountry]
            case .converted(let current): [current]
            case .new: viewModel.screenState.selectedCountryList.map({ $0.code })
            case .none: [String]()
            }
            
            let disabledItems = switch countryListInputType {
            case .base: viewModel.screenState.selectedCountryList.map{ $0.code }
            case .converted(let current): viewModel.screenState.selectedCountryList
                    .filter { $0.code != current }
                    .map{ $0.code } + [viewModel.screenState.baseCountry]
            case .new: [viewModel.screenState.baseCountry]
            case .none: [String]()
            }
            
            SelectionCountryListScreenView(
                list: viewModel.screenState.countryList,
                initialSelected: selectedItems,
                isMultiple: (countryListInputType == .new),
                disabledItems: disabledItems,
                onClose: {
                    countryListInputType = nil
                },
                onResults: { result in
                    switch countryListInputType {
                    case .base:
                        guard let code = result.first else { break }
                        viewModel.updateBaseCountry(code: code)
                    case .converted(let current):
                        guard let newCode = result.first else { break }
                        viewModel.updateSelectedCountryToConvert(old: current, new: newCode)
                    case .new:
                        viewModel.addCountryToSelection(countryList: result)
                    case .none: countryListInputType = nil
                    }

                    countryListInputType = nil
                }
            )
                .presentationDetents([.fraction(1), .fraction(1)])
                .presentationDragIndicator(.hidden)
        })
        .onChange(of: countryListInputType) { value in
            isCountryListPopupShown = (countryListInputType != nil)
        }
    }
}

#Preview {
    CurrencyConvertScreenView(onNavResult: { _ in })
}
