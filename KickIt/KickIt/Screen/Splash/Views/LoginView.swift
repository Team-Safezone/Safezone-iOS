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
    @StateObject private var darkmodeViewModel = DarkmodeViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        ZStack(alignment: .leading) {
            OnBoarding()
            
                VStack(alignment: .center)
                {
                    Spacer()
                    // MARK: 카카오 로그인
                    Button(action: {
                        if UserApi.isKakaoTalkLoginAvailable() {
                            loginWithKakaoTalk()
                        } else {
                            loginWithKakaoAccount()
                        }
                    }) {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .foregroundStyle(.kakao)
                            .overlay {
                                HStack(alignment: .center, spacing: 88) {
                                    Image("kakao_logo")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 16, height: 16)
                                        .padding(.leading, 16)
                                    Text("카카오로 3초만에 로그인")
                                        .pretendardTextStyle(.Title2Style)
                                        .foregroundStyle(.black0)
                                    Spacer().frame(width: 10)
                                }
                            }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 5)
                    
                    // 애플 로그인
                    Button(action: {
                        viewModel.nextStep()
                    }) {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .foregroundStyle(.white0)
                            .overlay {
                                HStack(alignment: .center, spacing: 88) {
                                    Image("apple_logo")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 16, height: 16)
                                        .padding(.leading, 16)
                                    Text("       Apple로 로그인")
                                        .pretendardTextStyle(.Title2Style)
                                        .foregroundStyle(.black0)
                                    Spacer()
                                }
                            }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 10)
                }.padding(.bottom, 70)
            
            
        }.environment(\.colorScheme, .dark) // 무조건 다크모드
    }
    
    
    private func loginWithKakaoTalk() {
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let error = error {
                    print("Kakao Login Error: \(error)")
                    return
                }
                handleKakaoLoginSuccess()
            }
        }
        
        private func loginWithKakaoAccount() {
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                if let error = error {
                    print("Kakao Safari Login Error: \(error)")
                    return
                }
                handleKakaoLoginSuccess()
            }
        }
        
        private func handleKakaoLoginSuccess() {
            if KeyChain.shared.getKeyChainItem(key: .kakaoNickname) != nil {
                connectKakaoAPI()
            } else {
                findKakaoAccount()
            }
        }
        
        private func connectKakaoAPI() {
            guard let email = KeyChain.shared.getKeyChainItem(key: .kakaoEmail) else {
                print("카카오 이메일 정보 없음")
                return
            }
            
            viewModel.postKakaoLogin(request: KakaoLoginRequest(email: email)) { success in
                if success {
                    if let token = KeyChain.shared.getJwtToken() {
                        DispatchQueue.main.async {
                            authViewModel.login(with: token)
                        }
                    } else {
                        print("로그인 성공했지만 토큰이 없음")
                        DispatchQueue.main.async {
                            viewModel.nextStep() // 온보딩으로 이동
                        }
                    }
                } else {
                    print("카카오 로그인 실패")
                    DispatchQueue.main.async {
                        viewModel.nextStep() // 온보딩으로 이동
                    }
                }
            }
        }
        
        private func findKakaoAccount() {
            UserApi.shared.me { (user, error) in
                if let error = error {
                    print("Kakao Data Error: \(error)")
                    return
                }
                
                // 로그인 데이터 삭제용
                KeyChain.shared.deleteJwtToken()
                KeyChain.shared.deleteKakaoAccount()
                
                if let email = user?.kakaoAccount?.email {
                    KeyChain.shared.addKeyChainItem(key: .kakaoEmail, value: email)
                    print("키체인 이메일 저장 확인: \(KeyChain.shared.getKeyChainItem(key: .kakaoEmail) ?? "no data..")")
                    viewModel.userSignUpInfo.loginType = .kakao
                    
                    DispatchQueue.main.async {
                        viewModel.nextStep() // 온보딩으로 이동
                    }
                }
            }
        }
    }

#Preview {
    LoginView(viewModel: MainViewModel())
}
