//
//  SplashView.swift
//  KickIt
//
//  Created by 이윤지 on 5/10/24.
//

import SwiftUI

struct SplashView: View {
    @ObservedObject private var darkmodeViewModel = DarkmodeViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isAnimationComplete = false
    @ObservedObject private var mainViewModel = MainViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("splash")
                    .frame(width: 80, height: 102)
                    .zIndex(1.0)
                
                Color.background
                    .ignoresSafeArea()
                    .environment(\.colorScheme, .dark)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                checkAuthenticationStatus()
                                isAnimationComplete = true
                            }
                        }
                    }
            }
            .navigationDestination(isPresented: $isAnimationComplete) {
                if authViewModel.isAuthenticated {
                    ContentView()
                        .environmentObject(authViewModel)
                        .preferredColorScheme(darkmodeViewModel.isDarkMode ? .dark : .light)
                        .navigationBarBackButtonHidden(true)
                } else {
                    MainView(viewModel: mainViewModel)
                        .environmentObject(authViewModel)
                        .navigationBarBackButtonHidden(true)
                }
            }
        }.navigationBarBackButtonHidden()
    }
    
    private func checkAuthenticationStatus() {
        authViewModel.updateAuthenticationStatus()
    }
}

#Preview {
    SplashView()
}
