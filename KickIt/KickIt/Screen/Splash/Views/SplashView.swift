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
    @State private var isActive: Bool = false
    
    var body: some View {
        if isActive {
            MainView(viewModel: viewModel)
        } else {
            ZStack{
                Text("LOGO")
                    .font(.pretendard(.bold, size: 50))
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
                                    
                                    // 홈 화면으로 이동
                                    ContentView()
                                    
                                }
                                // 토큰이 없다면
                                else {
                                    print("토큰 존재X")
                                    print("키체인 이메일 저장 확인: \(KeyChain.shared.getKeyChainItem(key: .kakaoEmail) ?? "no data..")")
                                    // 로그인 화면으로 이동
                                    isActive = true
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
