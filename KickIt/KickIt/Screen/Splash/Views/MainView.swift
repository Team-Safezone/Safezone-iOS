//
//  MainView.swift
//  KickIt
//
//  Created by DaeunLee on 9/18/24.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        VStack {
            switch viewModel.currentStep {
            case 0:
                LoginView(viewModel: viewModel)
            case 1:
                SettingNameView(viewModel: viewModel)
            case 2:
                SettingFavView(viewModel: viewModel)
            case 3:
                AcceptingView(viewModel: viewModel)
            default:
                SplashView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    MainView()
}
