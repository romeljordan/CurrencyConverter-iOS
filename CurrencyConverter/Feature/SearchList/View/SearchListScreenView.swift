//
//  ContentView.swift
//  CurrencyConverter
//
//  Created by androiddev on 11/18/24.
//

import SwiftUI

struct SearchListScreenView: View {
    @State var value: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                TextField("Search", text: $value)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                    .onChange(of: value) { newValue, _ in
//                        let parseValue = (value.isEmpty) ? 0 : Double(value)
//                        onValueChanged?(parseValue!)
                    }
                Spacer()
                
                Button {
                    // TODO: add click functionality
                } label: {
                    Text("Add")
                }
            }
            
            ScrollView(.vertical) {
                LazyVStack(spacing: 0) {
//                    ForEach(viewModel.countryConvertList, id: \.self) { code in
//                        let currency = viewModel.getCurrency(code: code)
//                        if (currency != nil) {
//                            CurrencyRowView(currency: currency!, countryCode: code, value: value * (viewModel.rates[currency!.code.lowercased()] ?? 0))
//                        }
//                    }
                    ForEach(1...10, id: \.self) { _ in
                        SearchItemView(countryCode: "us", name: "United States", isSelected: false)
                    }
                }
            }
            
        }
        .padding()
        .background(Color.black)
    }
}



#Preview {
    SearchListScreenView()
}
