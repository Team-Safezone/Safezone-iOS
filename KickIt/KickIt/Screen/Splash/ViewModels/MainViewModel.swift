//
//  MainViewModel.swift
//  KickIt
//
//  Created by DaeunLee on 9/18/24.
//

import Foundation
import Combine

/// 사용자 회원가입 정보를 저장하는 구조체
struct UserSignUpInfo {
    var nickname: String = ""
    var favoriteTeams: [String] = []
    var agreeToMarketing: Bool = false
    
    /// SignUpRequest로 변환하는 메서드
    func toSignUpData() -> SignUpRequest {
        return SignUpRequest(nickname: nickname, favoriteTeam: favoriteTeams, marketingConsent: agreeToMarketing)
    }
}

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
    
    /// 회원가입 API 호출 메서드
    /// - Parameter completion: 회원가입 성공 여부를 전달하는 클로저
    func signUp(completion: @escaping (Bool) -> Void) {
        // UserSignUpInfo를 SignUpRequest로 변환
        let signUpData = userSignUpInfo.toSignUpData()
        
        // 회원가입 API 호출
        UserAPI.shared.signUp(signUpData: signUpData)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                 print("Error Sign up: \(error)")
                                }
            } receiveValue: { success in
                print("Sign up result: \(success)")
                completion(success)
            }
            .store(in: &cancellables)
    }
}
