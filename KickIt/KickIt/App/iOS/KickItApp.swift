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
    @StateObject private var viewModel = MainViewModel()
    
    init() {
            KakaoSDK.initSDK(appKey: Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY") as! String)
        }
        
        var body: some Scene {
            WindowGroup {
                SplashView(viewModel: viewModel)
                    .onOpenURL { url in
                        if (AuthApi.isKakaoTalkLoginUrl(url)) {
                            _ = AuthController.handleOpenUrl(url: url)
                    }
                }
            }
        }
    }
