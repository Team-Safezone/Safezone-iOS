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
                                isActive = true
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
