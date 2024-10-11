//
//  KickItApp.swift
//  KickIt
//
//  Created by 이윤지 on 5/10/24.
//

import SwiftUI

@main
struct KickItApp: App {
    @StateObject private var viewModel = MainViewModel()
    @StateObject private var myPageViewModel = MyPageViewModel()
    
    var body: some Scene {
        WindowGroup {
//            SplashView(viewModel: viewModel)
            ContentView()
                .environmentObject(myPageViewModel)
                .preferredColorScheme(myPageViewModel.isDarkMode ? .dark : .light)
        }
    }
}
