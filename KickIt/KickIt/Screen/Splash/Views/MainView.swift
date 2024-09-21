//
//  MainView.swift
//  KickIt
//
//  Created by DaeunLee on 9/18/24.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel
    
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
                Text("Error: Invalid step")
            }
        }
    }
}

#Preview {
    MainView(viewModel: MainViewModel())
}
