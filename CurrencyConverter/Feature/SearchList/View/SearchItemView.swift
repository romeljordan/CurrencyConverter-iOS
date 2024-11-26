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
    var isSelected: Bool = false
    
    var onToggleListener: ((Bool) -> Void)? = nil
    
    init(countryCode: String, name: String, isSelected: Bool, onToggleListener: ((Bool) -> Void)? = nil) {
        self.countryCode = countryCode
        self.countryName = name
        self.isSelected = isSelected
        self.onToggleListener = onToggleListener
    }
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: "https://flagsapi.com/\(countryCode.uppercased())/flat/32.png"))
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
            
            Text(countryName)
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(Color.white)
                .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
            Spacer()
//            Toggle(isOn: $isSelected, label: {})
//                .onTapGesture {
//                    isSelected = !isSelected
//                    onToggleListener?(isSelected)
//                }
            
            Image(systemName: "checkmark.circle.fill")
                .frame(width: 24, height: 24)
                .aspectRatio(contentMode: .fill)
                .foregroundStyle(
                    (isSelected) ? Color.green : Color.gray
                )
                .onTapGesture(perform: {
                    onToggleListener?(!isSelected)
                })
            
            
        }
        .padding(EdgeInsets(top: 8, leading: 4, bottom: 8, trailing: 4))
    }
}

#Preview {
    SearchItemView(countryCode: "us", name: "United States", isSelected: true)
        .background(Color.black)
}
