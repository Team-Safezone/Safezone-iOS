//
//  SettingNameViewModel.swift
//  KickIt
//
//  Created by DaeunLee on 9/14/24.
//

import Combine
import SwiftUI

class SettingNameViewModel: ObservableObject {
    /// 사용자가 입력한 닉네임
    @Published var nickname = ""
    /// 닉네임의 유효성 여부
    @Published var isNicknameValid = false
    /// 에러 메시지
    @Published var errorMessage = ""
    /// 중복 검사 중 여부
    @Published var isCheckingDuplicate = false
    
    private var cancellables = Set<AnyCancellable>()
    private var nicknameCheckSubject = PassthroughSubject<String, Never>()
    
    init() {
        setupNicknameCheck()
    }
    
    /// 닉네임 체크 설정
    private func setupNicknameCheck() {
        nicknameCheckSubject
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .sink { [weak self] nickname in
                self?.validateNickname(nickname)
            }
            .store(in: &cancellables)
        
        $nickname
            .sink { [weak self] nickname in
                self?.nicknameCheckSubject.send(nickname)
            }
            .store(in: &cancellables)
    }
    
    /// 닉네임 유효성 검사 및 중복 체크
    /// - Parameter nickname: 검사할 닉네임
    private func validateNickname(_ nickname: String) {
        let nicknameRegex = "^[a-zA-Z0-9가-힣]{2,10}$"
        let nicknamePredicate = NSPredicate(format: "SELF MATCHES %@", nicknameRegex)
        
        if !nicknamePredicate.evaluate(with: nickname) {
            isNicknameValid = false
            errorMessage = "사용 불가능한 닉네임입니다"
            return
        }
        
        isCheckingDuplicate = true
        
        UserAPI.shared.checkNicknameDuplicate(nickname: nickname)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isCheckingDuplicate = false
                if case .failure(let error) = completion {
                    self?.isNicknameValid = false
                    self?.errorMessage = "중복 검사 중 오류가 발생했습니다" // 에러 명칭 \(error.localizedDescription)
                }
            } receiveValue: { [weak self] isDuplicate in
                self?.isNicknameValid = !isDuplicate
                self?.errorMessage = isDuplicate ? "중복된 닉네임입니다" : ""
            }
            .store(in: &cancellables)
    }
    
    /// TextField 테두리 색상
    var borderColor: Color {
        if nickname.isEmpty {
            return .gray900
        } else if isNicknameValid {
            return .lime
        } else {
            return .red0
        }
    }
    
    /// 상태 메시지
    var statusMessage: String {
        if nickname.isEmpty {
            return "2~10자 이내, 영문/한글/숫자만 입력 가능"
        } else if !errorMessage.isEmpty {
            return errorMessage
        } else if isNicknameValid {
            return "사용 가능한 닉네임입니다"
        } else {
            return "2~10자 이내, 영문/한글/숫자만 입력 가능"
        }
    }
    
    /// 상태 메시지 색상
    var statusColor: Color {
        if nickname.isEmpty || (!isNicknameValid && errorMessage.isEmpty) {
            return .gray
        } else if isNicknameValid {
            return .green
        } else {
            return .red
        }
    }
    
    /// 닉네임 설정 API 호출
    func setNickname(to mainViewModel: MainViewModel, completion: @escaping () -> Void) {
            guard isNicknameValid else {
                errorMessage = "유효하지 않은 닉네임입니다."
                return
            }
            
            mainViewModel.userSignUpInfo.nickname = nickname
            completion()
        }
    }
