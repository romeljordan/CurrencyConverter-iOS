//
//  SearchItemView.swift
//  CurrencyConverter
//
//  Created by androiddev on 11/25/24.
//

import SwiftUI

struct SearchItemView: View {
    var countryCode: String
    var countryName: String
    @State var isSelected: Bool = false
    
    var onToggleListener: ((Bool) -> Unit)? = nil
    
    init(countryCode: String, name: String, isSelected: Bool) {
        self.countryCode = countryCode
        self.countryName = name
        self.isSelected = isSelected
    }
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: "https://flagsapi.com/\(countryCode.uppercased())/flat/32.png"))
                .aspectRatio(contentMode: .fit)
                .frame(width: 16, height: 16)
            
            Text(countryName)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.white)
                .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .frame(width: 24, height: 24)
                .aspectRatio(contentMode: .fill)
                .foregroundStyle(
                    (isSelected) ? Color.green : Color.gray
                )
                .onTapGesture(perform: {
                    isSelected = !isSelected
                    onToggleListener?(isSelected)
                })
        }
        .padding(16)
    }
}

#Preview {
    SearchItemView(countryCode: "us", name: "United States", isSelected: true)
        .background(Color.black)
}
