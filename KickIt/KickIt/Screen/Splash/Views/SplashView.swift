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
    @Binding var isAnimationComplete: Bool
    @ObservedObject private var mainViewModel = MainViewModel()
    
    var body: some View {
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
    }
    
    private func checkAuthenticationStatus() {
        authViewModel.updateAuthenticationStatus()
    }
}

#Preview {
    SplashView(isAnimationComplete: .constant(true))
}
