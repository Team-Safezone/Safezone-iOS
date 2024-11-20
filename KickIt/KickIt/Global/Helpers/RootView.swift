//
//  RootView.swift
//  KickIt
//
//  Created by DaeunLee on 11/12/24.
//

import SwiftUI

struct RootView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var darkmodeViewModel = DarkmodeViewModel()
    @State private var isAnimationComplete = false
    
    var body: some View {
        NavigationStack {
            Group {
                if !isAnimationComplete {
                    SplashView(isAnimationComplete: $isAnimationComplete)
                        .environmentObject(authViewModel)
                } else if authViewModel.isAuthenticated {
                    ContentView()
                        .environmentObject(authViewModel)
                        .preferredColorScheme(darkmodeViewModel.isDarkMode ? .dark : .light)
                } else {
                    MainView(viewModel: MainViewModel())
                        .environmentObject(authViewModel)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
