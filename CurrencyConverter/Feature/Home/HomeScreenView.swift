//
//  HomeScreenView.swift
//  CurrencyConverter
//
//  Created by androiddev on 11/30/24.
//

import SwiftUI

struct HomeScreenView: View {
    
    var body: some View {
        VStack {
            VStack {
                Image("icon")
                    .resizable()
                    .frame(width: 175, height: 175)
                    .aspectRatio(contentMode: .fit)
                
                Text("Currency Convert".uppercased())
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(Color.white)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: UIScreen.main.bounds.height / 2)
            
            VStack {
                Spacer()
                
                Button(
                    action: {},
                    label: {
                        Text("Get Started")
                            .font(Font.system(size: 20, weight: .semibold))
                            .foregroundStyle(Color.white)
                    }
                )
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity)
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.white, lineWidth: 1)
                )
            }
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 60, trailing: 16))
        }
        .background(Color.black)
    }
}

#Preview {
    HomeScreenView()
}
