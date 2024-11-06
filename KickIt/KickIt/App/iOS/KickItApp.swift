//
//  KickItApp.swift
//  KickIt
//
//  Created by 이윤지 on 5/10/24.
//

import SwiftUI
import KakaoSDKAuth
import KakaoSDKCommon

@main
struct KickItApp: App {
    /// 앱 델리게이트 어댑터
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject private var viewModel = MainViewModel()
    
    // 로그인 상태를 추적하는 새로운 상태 변수
    @State private var isLoggedIn = false
    
    /// 마이페이지 뷰모델
    @StateObject private var myPageViewModel = MyPageViewModel()
    
    init() {
            KakaoSDK.initSDK(appKey: Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY") as! String)
        }
        
        var body: some Scene {
            WindowGroup {
                Group {
                    if isLoggedIn {
                        ContentView( isLoggedIn: $isLoggedIn)
                            .preferredColorScheme(myPageViewModel.isDarkMode ? .dark : .light)
                            .environmentObject(viewModel)
                        
                    } else {
                        LoginView(viewModel: viewModel, isLoggedIn: $isLoggedIn)
                    }
                }
                .onAppear {
                    // 앱 시작 시 로그인 상태 확인
                    isLoggedIn = KeyChain.shared.getJwtToken() != nil
                }
                .onOpenURL { url in
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
            }
        }
    }
