//
//  SelectionCountryListScreenView.swift
//  CurrencyConverter
//
//  Created by androiddev on 11/18/24.
//

import SwiftUI

struct SelectionCountryListScreenView: View {
    var list: [Country]
    var isMultiple: Bool = true
    
    var onResults: ([String]) -> Void
    var onClose: (() -> Void)? = nil
    
    @State var searchText: String = ""
    @State var selected: [String] = []
    
    init(
        list: [Country],
        initialSelected: [String] = [],
        isMultiple: Bool = true,
        disabledItems: [String] = [],
        onClose: (() -> Void)? = nil,
        onResults: @escaping ([String]) -> Void
    ) {
        self.list = list
            .sorted(by: { $0.name < $1.name })
            .filter { !disabledItems.contains($0.code) }
        self.isMultiple = isMultiple
        self.selected = initialSelected
        self.onResults = onResults
        self.onClose = onClose
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 16) {
                Button(
                    "",
                    systemImage: "arrow.left",
                    action: {
                        onClose?()
                    }
                )
                    .foregroundStyle(Color.white)
                
                Text("Country List")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(Color.white)
                
                Spacer()
                
                if (isMultiple) {
                    Button {
                        onResults(selected)
                    } label: {
                        Text("Add")
                            .font(.system(size: 18, weight: .medium))
                    }
                    .disabled(selected.isEmpty)
                }
            }
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color.white)
                TextField(
                    "",
                    text: $searchText,
                    prompt: Text("Search")
                        .font(
                            .system(size: 17)
                        )
                        .foregroundStyle(Color.white.opacity(0.8))
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
            
            ScrollViewReader { scrollValue in
                ScrollView(.vertical) {
                    LazyVStack(spacing: 12) {
                        let shownList = getSortedList()
                        ForEach(shownList, id: \.code) { item in
                            SelectionCountryItemView(
                                countryCode: item.code,
                                name: item.name,
                                isSelected: selected.contains(item.code),
                                isSingleMode: !isMultiple,
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
                    .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                }
                .onAppear {
                    if !isMultiple {
                        scrollValue.scrollTo(selected.first, anchor: .center)
                    }
                }
            }
        }
        .padding()
        .background(Color.black)
    }
    
    private func getSortedList() -> [Country] {
        if (searchText.isEmpty) {
            return list
        }
        
        return if (searchText.count == 1) {
            list.filter { country in
                country.name.first?.lowercased() ==  searchText.first?.lowercased()
            }
        } else {
            list.filter { country in
                country.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
}

#Preview {
    SelectionCountryListScreenView(
        list: [Country(name: "United States", code: "us", currency: Currency(name: "Us Dollar", code: "usd"))],
        initialSelected: ["us"]
    ) { results in
        
    }
}
