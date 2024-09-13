//
//  SettingNameView.swift
//  KickIt
//
//  Created by DaeunLee on 9/8/24.
//

import SwiftUI

struct SettingNameView: View {
    @State private var nickname = ""
    @State private var isNicknameValid = false
    @State private var errorMessage = ""
    @State private var isCheckingDuplicate = false
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading) {
                // 상단 Progress Circle
                HStack(spacing: 10) {
                    Spacer()
                    CircleView(num: "1", numColor: .black, bgColor: .lime)
                    CircleView(num: "2", numColor: .gray600, bgColor: .gray900)
                }
                .padding(.horizontal, 24)
                .padding(.top, 10)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("만나서 반가워요\n닉네임을 입력해주세요")
                        .pretendardTextStyle(.H2Style)
                    Text("닉네임은 언제든지 변경할 수 있어요!")
                        .pretendardTextStyle(.Body2Style)
                        .foregroundStyle(.gray500)
                } //:VSTACK
                .padding(.leading, 16)
                .padding(.top, 50)
                .padding(.bottom, 36)
                
                VStack(alignment: .leading, spacing: 4){
                    TextField("이름", text: $nickname)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.leading, 12)
                        .padding(.vertical, 12)
                        .onChange(of: nickname) { _, _ in
                            validateNickname()
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(borderColor, lineWidth: 1)
                        )
                    
                    Text(statusMessage)
                        .foregroundColor(statusColor)
                        .pretendardTextStyle(.Caption1Style)
                        .padding(.leading, 4)
                }//:VSTACK
                .padding(.horizontal, 24)
                
            }//:VSTACK
            Spacer()
            
            NavigationLink{
                SettingFavView()
            }label: {
                DesignWideButton(
                    label: "다음",
                    labelColor: isNicknameValid ? .background : .gray400,
                    btnBGColor: isNicknameValid ? .lime : .gray600
                )
                .disabled(!isNicknameValid)
            }//:NAVIGATIONLINK
        }//:NAVIGATIONSTACK
        .navigationBarBackButtonHidden(true)
    }
    
    // TextField 테두리 색상
    private var borderColor: Color {
        if nickname.isEmpty {
            return .gray900
        } else if isNicknameValid {
            return .lime
        } else {
            return .red0
        }
    }
    
    // 경고, 성공 메시지 출력
    private var statusMessage: String {
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
    
    // 유효 닉네임별 색상 변경
    private var statusColor: Color {
        if nickname.isEmpty || (!isNicknameValid && errorMessage.isEmpty) {
            return .gray
        } else if isNicknameValid {
            return .green
        } else {
            return .red
        }
    }
    
    // 유효 닉네임 설정
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
            // 여기에서 데이터베이스 중복 검사를 수행합니다.
            // 예시를 위해 비동기 작업을 시뮬레이션합니다.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // 향후 데이터베이스 쿼리로 대체
                let isDuplicate = false // 예시: 중복이 아니라고 가정
                
                if isDuplicate {
                    isNicknameValid = false
                    errorMessage = "중복된 닉네임입니다"
                } else {
                    isNicknameValid = true
                    errorMessage = ""
                }
                isCheckingDuplicate = false
            }
        }
    }
}

// 상단 표기
struct CircleView: View {
    var num: String
    var numColor: Color
    var bgColor: Color
    
    var body: some View {
        Circle()
            .frame(width: 24, height: 24)
            .foregroundColor(bgColor)
            .overlay(
                Text(num)
                    .font(.caption)
                    .foregroundColor(numColor)
            )
    }
}

#Preview {
    SettingNameView()
}
