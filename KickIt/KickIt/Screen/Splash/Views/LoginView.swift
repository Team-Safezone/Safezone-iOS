//
//  LoginView.swift
//  KickIt
//
//  Created by DaeunLee on 9/8/24.
//

import SwiftUI
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

// 로그인 화면
struct LoginView: View {
    
    @ObservedObject var viewModel: MainViewModel
    
    @State private var isHome = false
    
    /// 마이페이지 뷰모델
    @StateObject private var myPageViewModel = MyPageViewModel()
    
    var body: some View {
        if isHome {
           ContentView()
               .preferredColorScheme(myPageViewModel.isDarkMode ? .dark : .light)
       }
        else {
            ZStack(alignment: .leading) {
                Color.background.ignoresSafeArea()
                
                Image("login_bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                VStack(alignment: .leading)  {
                    VStack(alignment: .leading)
                    {
                        Spacer()
                        VStack(alignment: .leading, spacing: 5){
                            Text("지금 로그인하고, 축구를 보며")
                                .font(.pretendard(.medium, size: 20))
                            Text("두근거렸던 순간을 확인해보세요!")
                                .font(.pretendard(.bold, size: 20))
                        } //:VSTACK
                        .padding(.bottom, 63)
                        
                        // MARK: 카카오 로그인
                        Button(action: {
                            // 카카오톡 앱 설치 여부 확인
                            if (UserApi.isKakaoTalkLoginAvailable()) {
                                // 카카오톡 앱을 통한 로그인 실행
                                UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                                    if let error = error {
                                        print("Kakao Login Error: \(error)")
                                    }
                                    
                                    // KeyChain에 카카오 닉네임이 저장되어 있다면
                                    if let nickName = KeyChain.shared.getKeyChainItem(key: .kakaoNickname) {
                                        connectKakaoAPI()
                                    }
                                    // KeyChain에 카카오 닉네임이 저장되어 있지 않다면
                                    else {
                                        findKakaoAccount()
                                    }
                                }
                            }
                            // 사파리를 통한 카카오 로그인 진행
                            else {
                                UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                                    if let error = error {
                                        print("Kakao Safari Login Error: \(error)")
                                    }
                                    
                                    // KeyChain에 카카오 닉네임이 저장되어 있다면
                                    if let nickname = KeyChain.shared.getKeyChainItem(key: .kakaoNickname) {
                                        connectKakaoAPI()
                                    }
                                    // KeyChain에 카카오 이메일이 저장되어 있지 않다면
                                    else {
                                        findKakaoAccount()
                                    }
                                }
                            }
                        }) {
                            RoundedRectangle(cornerRadius: 8)
                                .frame(maxWidth: .infinity, maxHeight: 48)
                                .foregroundStyle(.kakao)
                                .overlay {
                                    HStack(alignment: .center, spacing: 88) {
                                        Image("kakao_logo")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 16, height: 16)
                                            .padding(.leading, 16)
                                        Text("카카오로 로그인")
                                            .pretendardTextStyle(.Body1Style)
                                            .foregroundStyle(.black0)
                                            .padding(.leading, 12)
                                        Spacer()
                                    }
                                }
                        }
                    }
                    .padding(.bottom, 10)
                    
                    // 애플 로그인
                    Button(action: {
                        viewModel.nextStep()
                    }) {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(maxWidth: .infinity, maxHeight: 48)
                            .foregroundStyle(.white0)
                            .overlay {
                                HStack(alignment: .center, spacing: 88) {
                                    Image("apple_logo")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 16, height: 16)
                                        .padding(.leading, 16)
                                    Text("Apple로 로그인")
                                        .pretendardTextStyle(.Body1Style)
                                        .foregroundStyle(.black0)
                                        .padding(.leading, 12)
                                    Spacer()
                                }
                            }
                    }
                    .padding(.bottom, 96)
                }
                .padding(.horizontal, 16)
            }.environment(\.colorScheme, .dark) // 무조건 다크모드
        }
    }
    
    /// 카카오 로그인 API 연결
    private func connectKakaoAPI() {
        // 카카오 로그인 API 연결
        viewModel.postKakaoLogin(request: KakaoLoginRequest(email: KeyChain.shared.getKeyChainItem(key: .kakaoEmail)!)) { success in
            // 로그인 성공 시, 홈 화면으로 이동
            if success {
                isHome = true
            }
            else {
                print("카카오 로그인 실패")
                isHome = false
            }
        }
    }
    
    /// 카카오 이메일 정보 찾기
    private func findKakaoAccount() {
        // 카카오 이메일 정보 가져오기
        UserApi.shared.me {(user, error) in
            if let error = error {
                print("Kakao Data Error: \(error)")
            }
            
            print(user?.kakaoAccount?.email ?? "no email..")
            
            // 카카오 이메일 저장
            if let email = user?.kakaoAccount?.email {
                KeyChain.shared.addKeyChainItem(key: .kakaoEmail, value: email)
                print("키체인 이메일 저장 확인: \(KeyChain.shared.getKeyChainItem(key: .kakaoEmail) ?? "no data..")")
                viewModel.userSignUpInfo.loginType = .kakao
                
                // 회원가입 다음단계 진행
                viewModel.nextStep()
            }
        }
    }
}

#Preview {
    LoginView(viewModel: MainViewModel())
}
