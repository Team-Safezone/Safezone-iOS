//
//  SplashView.swift
//  KickIt
//
//  Created by 이윤지 on 5/10/24.
//

import SwiftUI

struct SplashView: View {
    @ObservedObject var viewModel: MainViewModel
    @State private var isActive: Bool = false
    
    var body: some View {
        if isActive {
            LoginView(viewModel: viewModel)
        } else {
            ZStack{
                Text("LOGO")
                    .font(.pretendard(.bold, size: 50))
                    .zIndex(1.0)
                Color.background
                    .ignoresSafeArea()
                    .onAppear{
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                            timer.invalidate()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
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
    SplashView(viewModel: MainViewModel())
}
