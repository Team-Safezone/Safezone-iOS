//
//  SettingNameViewModel.swift
//  KickIt
//
//  Created by DaeunLee on 9/14/24.
//

import Combine
import SwiftUI

// 닉네임 설정 뷰모델
class SettingNameViewModel: ObservableObject {
    @Published var nickname = ""
    @Published var isNicknameValid = false
    @Published var errorMessage = ""
    @Published private(set) var isCheckingDuplicate = false
    
    private var cancellables = Set<AnyCancellable>()
    
    // 박스 라인 색
    var borderColor: Color {
        nickname.isEmpty ? .gray900 : (isNicknameValid ? .white0 : .red0)
    }
    
    // 박스 메시지
    var statusMessage: String {
        if nickname.isEmpty || (!isNicknameValid && errorMessage.isEmpty) {
            return "2~10자 이내, 영문/한글/숫자만 입력 가능"
        } else if !errorMessage.isEmpty {
            return errorMessage
        } else {
            return "사용 가능한 닉네임입니다"
        }
    }
    
    // 박스 글씨색
    var statusColor: Color {
        if nickname.isEmpty || (!isNicknameValid && errorMessage.isEmpty) {
            return .gray300
        } else if isNicknameValid {
            return .lime
        } else {
            return .red0
        }
    }
    
    // 유효한 닉네임
    func validateNickname() {
        let nicknameRegex = "^[a-zA-Z0-9가-힣]{2,10}$"
        let nicknamePredicate = NSPredicate(format: "SELF MATCHES %@", nicknameRegex)
        
        
        // MARK: 현재는 유효한 닉네임인지만 판단
        if nicknamePredicate.evaluate(with: nickname) {
            isNicknameValid = true
            errorMessage = "사용 가능한 닉네임입니다"
        } else {
            isNicknameValid = false
            errorMessage = "사용 불가능한 닉네임입니다"
        }
        
        // MARK: API 개발 전까지 호출 부분 잠시 주석 처리
        /*
         guard nicknamePredicate.evaluate(with: nickname) else {
         isNicknameValid = false
         errorMessage = "사용 불가능한 닉네임입니다"
         return
         }
         
         isCheckingDuplicate = true
         
         UserAPI.shared.checkNicknameDuplicate(nickname: nickname)
         .receive(on: DispatchQueue.main)
         .sink { [weak self] completion in
         self?.isCheckingDuplicate = false
         if case .failure = completion {
         self?.isNicknameValid = false
         self?.errorMessage = "중복 검사 중 오류가 발생했습니다"
         }
         } receiveValue: { [weak self] isDuplicate in
         self?.isNicknameValid = !isDuplicate
         self?.errorMessage = isDuplicate ? "중복된 닉네임입니다" : ""
         }
         .store(in: &cancellables)
         }
         */
    }
    
    // 규칙에 맞지 않은 닉네임 설정
    func setNickname(to mainViewModel: MainViewModel, completion: @escaping () -> Void) {
        guard isNicknameValid else {
            errorMessage = "유효하지 않은 닉네임입니다."
            return
        }
        
        mainViewModel.userSignUpInfo.nickname = nickname
        completion()
    }
}
