//
//  SplashView.swift
//  KickIt
//
//  Created by 이윤지 on 5/10/24.
//

import SwiftUI

/// 스플래시 화면
struct SplashView: View {
    @ObservedObject var viewModel: MainViewModel
    @State private var isLogin: Bool = false
    @State private var isHome: Bool = false
    
    @ObservedObject private var darkmodeViewModel = DarkmodeViewModel()
    
    
    var body: some View {
        if isLogin {
            MainView(viewModel: viewModel)
        }
        else if isHome {
            ContentView()
                .preferredColorScheme(darkmodeViewModel.isDarkMode ? .dark : .light)
        }
        else {
            ZStack{
                Image("AppIcon")
                    .frame(width: 80, height: 102)
                    .zIndex(1.0)
                Color.background
                    .ignoresSafeArea()
                    .environment(\.colorScheme, .dark) // 무조건 다크모드
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                // 토큰이 있다면
                                if let token = KeyChain.shared.getJwtToken() {
                                    print("토큰 존재 O: \(token)")
                                    print("키체인 이메일 저장 확인: \(KeyChain.shared.getKeyChainItem(key: .kakaoEmail) ?? "no data..")")
                                    print("키체인 닉네임 저장 확인: \(KeyChain.shared.getKeyChainItem(key: .kakaoNickname) ?? "no data..")")
                                    
                                    // 홈 화면으로 이동
                                    isHome = true
                                }
                                // 토큰이 없다면
                                else {
                                    print("토큰 존재X")
                                    print("키체인 이메일 저장 확인: \(KeyChain.shared.getKeyChainItem(key: .kakaoEmail) ?? "no data..")")
                                    print("키체인 닉네임 저장 확인: \(KeyChain.shared.getKeyChainItem(key: .kakaoNickname) ?? "no data..")")
                                    
                                    // 로그인 화면으로 이동
                                    isLogin = true
                                }
                            }
                        }
                    }//:COLOR
            }//:ZSTACK
        }//:IF
    }
}

#Preview {
    SplashView(viewModel: MainViewModel())
}
