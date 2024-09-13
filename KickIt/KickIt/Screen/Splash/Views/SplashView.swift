//
//  ContentView.swift
//  KickIt
//
//  Created by 이윤지 on 5/10/24.
//

import SwiftUI

/// 스플래시 화면
struct SplashView: View {
    @State private var isActive: Bool = false
    var body: some View {
        if isActive {
            LoginView()
        } else {
            ZStack{
                Text("LOGO")
                    .font(.pretendard(.bold, size: 50))
                    .zIndex(1.0)
                Color.black
                    .ignoresSafeArea()
                    .onAppear{
                        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                            timer.invalidate()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation(.linear(duration: -5)) {
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
    SplashView()
}
