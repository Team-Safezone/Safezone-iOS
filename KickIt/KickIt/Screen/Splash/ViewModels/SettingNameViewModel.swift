//
//  SettingNameViewModel.swift
//  KickIt
//
//  Created by DaeunLee on 9/13/24.
//

import SwiftUI
import Combine

class SettingNameViewModel: ObservableObject {
    @Published var nickname = "" {
        didSet {
            validateNickname()
        }
    }
    @Published var isNicknameValid = false
    @Published var errorMessage = ""
    @Published var isCheckingDuplicate = false
    
    // 닉네임 검증 로직
    private func validateNickname() {
        let nicknameRegex = "^[a-zA-Z0-9가-힣]{2,10}$"
        let nicknamePredicate = NSPredicate(format: "SELF MATCHES %@", nicknameRegex)
        
        if nickname.isEmpty {
            isNicknameValid = false
            errorMessage = ""
        } else if !nicknamePredicate.evaluate(with: nickname) {
            isNicknameValid = false
            errorMessage = "사용 불가능한 닉네임입니다"
        } else {
            isCheckingDuplicate = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // 예시를 위한 더미 중복 검사
                let isDuplicate = false // 실제 데이터베이스 쿼리 결과에 따라 변경
                
                if isDuplicate {
                    self.isNicknameValid = false
                    self.errorMessage = "중복된 닉네임입니다"
                } else {
                    self.isNicknameValid = true
                    self.errorMessage = ""
                }
                self.isCheckingDuplicate = false
            }
        }
    }
    
    // TextField 테두리 색상
    var borderColor: Color {
        if nickname.isEmpty {
            return .gray900
        } else if isNicknameValid {
            return .lime
        } else {
            return .red0
        }
    }
    
    // 상태 메시지
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
    
    // 상태 메시지 색상
    var statusColor: Color {
        if nickname.isEmpty || (!isNicknameValid && errorMessage.isEmpty) {
            return .gray
        } else if isNicknameValid {
            return .green
        } else {
            return .red
        }
    }
}

