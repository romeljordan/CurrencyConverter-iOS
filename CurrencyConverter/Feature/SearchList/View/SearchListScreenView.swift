//
//  ContentView.swift
//  CurrencyConverter
//
//  Created by androiddev on 11/18/24.
//

import SwiftUI

struct SearchListScreenView: View {
    var list: [Country]
    var isMultiple: Bool = true
    
    var onResults: ([String]) -> Void
    
    @State var searchText: String = ""
    @State var selected: [String] = []
    
    init(list: [Country], initialSelected: [String] = [], isMultiple: Bool = true, onResults: @escaping ([String]) -> Void) {
        self.list = list.sorted(by: { $0.name < $1.name })
        self.isMultiple = isMultiple
        self.selected = initialSelected
        self.onResults = onResults
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(Color.white)
                    TextField(
                        "",
                        text: $searchText,
                        prompt: Text("Search")
                            .font(
                                .system(size: 18,
                                        weight: .medium,
                                        design: .monospaced)
                            )
                            .foregroundStyle(Color.white)
                    )
                        .keyboardType(.decimalPad)
                        .onChange(of: searchText) { newValue, _ in
                            searchText = newValue
                        }
                        .foregroundStyle(Color.white)
                        .padding(4)
                    Spacer()
                    
                }
                .padding(EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray))
                
                
                Button {
                    onResults(selected)
                } label: {
                    Text("Add")
                }
            }
            
            
            ScrollView(.vertical) {
                LazyVStack(spacing: 8) {
                    ForEach(list, id: \.self) { item in
                        SearchItemView(
                            countryCode: item.code,
                            name: item.name,
                            isSelected: selected.contains(item.code),
                            onToggleListener: { value in
                                if (isMultiple) {
                                    switch value {
                                    case true:
                                        selected.append(item.code)
                                    case false:
                                        selected.removeAll(where: { $0 == item.code })
                                    }
                                } else {
                                    onResults([item.code])
                                }
                            }
                        )
                    }
                }
            }
            
        }
        .padding()
        .background(Color.black)
    }
}



#Preview {
    SearchListScreenView(
        list: [Country(name: "United States", code: "us", currency: Currency(name: "Us Dollar", code: "usd"))],
        initialSelected: ["us"]
    ) { results in
        
    }
}
