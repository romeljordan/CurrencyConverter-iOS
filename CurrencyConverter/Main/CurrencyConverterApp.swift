//
//  CurrencyConverterApp.swift
//  CurrencyConverter
//
//  Created by androiddev on 11/18/24.
//

import SwiftUI

@main
struct CurrencyConverterApp: App {
    @State var navPath = NavigationPath()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navPath) {
                VStack {
                    HomeScreenView { result in
                        switch result {
                        case .MoveToConverter:
                            navPath.append(CurrencyConvertNavigation.CurrencyConverter)
                        }
                    }
                }.navigationDestination(for: CurrencyConvertNavigation.self) { navType in
                    switch navType {
                    case .CurrencyConverter:
                        CurrencyConvertScreenView { result in
                            switch result {
                            case .MoveBack:
                                navPath.removeLast()
                            }
                        }
                        .navigationBarBackButtonHidden()
                    case .Home:
                        HomeScreenView { result in
                            switch result {
                            case .MoveToConverter:
                                navPath.append(CurrencyConvertNavigation.CurrencyConverter)
                            }
                        }
                    }
                }
            }
        }
    }
}
