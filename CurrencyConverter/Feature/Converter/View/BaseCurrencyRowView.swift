//
//  BaseCurrencyRowView.swift
//  CurrencyConverter
//
//  Created by androiddev on 11/20/24.
//
import SwiftUI


struct BaseCurrencyRowView: View {
    var currency: Currency
    var countryCode: String
    var onValueChanged: ((_ newValue: Double) -> Void)? = nil
    var onUpdateValueListener: (() -> Void)? = nil
    
    @State var value: String = "0"
    
    init(
        currency: Currency, countryCode: String, onUpdateValueListener: (() -> Void)? = nil, onValueChanged: ((_ newValue: Double) -> Void)? = nil
    ) {
        self.currency = currency
        self.countryCode = countryCode
        self.onValueChanged = onValueChanged
        self.onUpdateValueListener = onUpdateValueListener
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                AsyncImage(url: URL(string: "https://flagsapi.com/\(countryCode.uppercased())/flat/32.png"))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 35, height: 35)
                
                VStack(alignment: .leading) {
                    Text(currency.code.uppercased())
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(Color.white)
                    
                    Text(currency.name)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundStyle(Color.gray)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.gray)
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
            .contentShape(Rectangle())
            .onTapGesture {
                onUpdateValueListener?()
            }
            
            TextField("", text: $value)
                .textFieldStyle(WhiteRoundedBorder())
                .keyboardType(.decimalPad)
                .onChange(of: value) { newValue, _ in
                    let parseValue = (value.isEmpty) ? 0 : Double(value)
                    onValueChanged?(parseValue!)
                }
        }
        .padding(16)
        .background(AppColor.secondary)
        .clipShape(.rect(cornerRadius: 20))
    }
}

fileprivate struct WhiteRoundedBorder: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
            configuration
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.white, lineWidth: 2)
                )
                .foregroundStyle(Color.white)
                .font(.system(size: 20, weight: .semibold))
        }
}

#Preview {
    HStack {
        BaseCurrencyRowView(currency: Currency(name: "US Dollar", code: "usd"), countryCode: "us")
    }
    .background(Color.black)
}
