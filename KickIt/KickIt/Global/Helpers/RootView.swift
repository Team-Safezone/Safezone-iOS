//
//  RootView.swift
//  KickIt
//
//  Created by DaeunLee on 11/12/24.
//

import SwiftUI

struct RootView: View {
    @ObservedObject var viewModel: MainViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var darkmodeViewModel = DarkmodeViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if authViewModel.isAuthenticated {
                    ContentView()
                        .preferredColorScheme(darkmodeViewModel.isDarkMode ? .dark : .light)
                        .navigationBarBackButtonHidden(true)
                } else {
                    MainView(viewModel: viewModel)
                        .navigationBarBackButtonHidden(true)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
