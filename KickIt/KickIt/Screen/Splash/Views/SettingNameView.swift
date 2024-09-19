//
//  SettingNameView.swift
//  KickIt
//
//  Created by DaeunLee on 9/8/24.
//

import SwiftUI

// 닉네임 설정 화면
struct SettingNameView: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        ZStack(alignment: .top){
            // 배경화면 색 지정
            Color.background
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
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
                }
                .padding(.leading, 16)
                .padding(.top, 50)
                .padding(.bottom, 36)
                
                VStack(alignment: .leading, spacing: 4) {
                    TextField("이름", text: $viewModel.settingNameViewModel.nickname)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .padding(.leading, 12)
                        .padding(.vertical, 15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(viewModel.settingNameViewModel.borderColor, lineWidth: 1)
                        )
                    // 안내 메시지 + 경고 메시지
                    Text(viewModel.settingNameViewModel.statusMessage)
                        .foregroundColor(viewModel.settingNameViewModel.statusColor)
                        .pretendardTextStyle(.Caption1Style)
                        .padding(.leading, 4)
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                // 닉네임이 유효할 경우에만 다음 버튼 활성화
                Button(action: {
                    if viewModel.settingNameViewModel.isNicknameValid {
                        viewModel.settingNameViewModel.setNickname {
                            viewModel.nextStep()
                        }
                    }
                }) {
                    DesignWideButton(
                        label: "다음",
                        labelColor: viewModel.settingNameViewModel.isNicknameValid ? .black0 : .gray400,
                        btnBGColor: viewModel.settingNameViewModel.isNicknameValid ? .lime : .gray600
                    )
                }
                .disabled(!viewModel.settingNameViewModel.isNicknameValid)
            }//:VSTACK
        }//:ZSTACK
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

#Preview{
    SettingNameView(viewModel: MainViewModel())
}
