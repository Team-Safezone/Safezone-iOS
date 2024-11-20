//
//  MainViewModel.swift
//  KickIt
//
//  Created by DaeunLee on 9/18/24.
//

import Foundation
import Combine

/// 메인 뷰 모델
class MainViewModel: ObservableObject {
    /// 현재 회원가입 단계
    @Published var currentStep: Int = 0
    /// 닉네임 설정 뷰 모델
    @Published var settingNameViewModel = SettingNameViewModel()
    /// 선호 팀 설정 뷰 모델
    @Published var settingFavViewModel = SettingFavViewModel()
    /// 약관 동의 뷰 모델
    @Published var acceptingViewModel = AcceptingViewModel()
    /// 사용자 회원가입 정보
    @Published var userSignUpInfo = UserSignUpInfo()
    
    private var cancellables = Set<AnyCancellable>()
    
    /// 다음 단계로 이동하는 메서드
    func nextStep() {
        currentStep += 1
    }
    
    /// 카카오 회원가입 API 호출 함수
    func postKakaoSignUp(request: KakaoSignUpRequest, completion: @escaping (Bool) -> (Void)) {
        UserAPI.shared.kakaoSignUp(request: request)
            .sink(receiveCompletion: { complete in
                switch complete {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    completion(false)
                case .finished:
                    break
                }
            },
            receiveValue: { token in
                print("카카오 회원가입 응답: \(token)")
                
                // 키체인에 jwt 토큰 저장
                KeyChain.shared.addJwtToken(token: token) // KeyChain에 토큰 저장
                
                // watchOS로 토큰 전송
                WatchSessionManager.shared.sendXAuthTokenToWatch(token)
                completion(true)
            })
            .store(in: &cancellables)
    }
    
    /// 카카오 로그인 API 호출 함수
    func postKakaoLogin(request: KakaoLoginRequest, completion: @escaping (Bool) -> (Void)) {
        UserAPI.shared.kakaoLogin(request: request)
            .sink(receiveCompletion: { complete in
                switch complete {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    completion(false)
                case .finished:
                    break
                }
            },
            receiveValue: { token in
                print("카카오 로그인 응답: \(token)")
                
                // 키체인에 jwt 토큰 저장
                KeyChain.shared.addJwtToken(token: token) // KeyChain에 토큰 저장
                
                // watchOS로 토큰 전송
                WatchSessionManager.shared.sendXAuthTokenToWatch(token)
                completion(true)
            })
            .store(in: &cancellables)
    }
}
