//
//  MainView.swift
//  KickIt
//
//  Created by DaeunLee on 9/18/24.
//

import SwiftUI

// 사용자 가입 온보딩
struct MainView: View {
    @ObservedObject var viewModel: MainViewModel
    
    // 로그아웃 상태
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        VStack {
            switch viewModel.currentStep {
            case 0:
                LoginView(viewModel: viewModel, isLoggedIn: $isLoggedIn)
            case 1:
                SettingNameView(viewModel: viewModel)
            case 2:
                SettingFavView(viewModel: viewModel)
            case 3:
                AcceptingView(viewModel: viewModel)
            default:
                Text("Error: Invalid step")
            }
        }
    }
}

#Preview {
    MainView(viewModel: MainViewModel(), isLoggedIn: .constant(true))
}
