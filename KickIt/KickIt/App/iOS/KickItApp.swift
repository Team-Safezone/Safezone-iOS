//
//  KickItApp.swift
//  KickIt
//
//  Created by 이윤지 on 5/10/24.
//

import SwiftUI

@main
struct KickItApp: App {
    /// 앱 델리게이트 어댑터
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    /// 마이페이지 뷰모델
    @StateObject private var myPageViewModel = MyPageViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(myPageViewModel)
                .preferredColorScheme(myPageViewModel.isDarkMode ? .dark : .light)
        }
    }
}
