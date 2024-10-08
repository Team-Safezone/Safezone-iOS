//
//  SettingNameView.swift
//  KickIt
//
//  Created by DaeunLee on 9/8/24.
//

import SwiftUI

struct SettingNameView: View {
    @ObservedObject var viewModel: MainViewModel
    @ObservedObject var settingNameViewModel: SettingNameViewModel
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        self.settingNameViewModel = viewModel.settingNameViewModel
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.background.ignoresSafeArea()
                .environment(\.colorScheme, .dark) // 무조건 다크모드
            
            VStack(alignment: .leading, spacing: 20) {
                // 회원 가입 과정 원
                progressIndicator
                // 제목
                titleSection
                // 닉네임 필드
                nicknameInputSection
                Spacer()
                // 다음 버튼
                nextButton
            }
            .padding()
        }.environment(\.colorScheme, .dark) // 무조건 다크모드
    }
    
    // 제목
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("만나서 반가워요\n닉네임을 입력해주세요")
                .pretendardTextStyle(.H2Style)
            Text("닉네임은 언제든지 변경할 수 있어요!")
                .pretendardTextStyle(.Body2Style)
                .foregroundStyle(.gray500)
        }.padding(.bottom, 36)
    }
    
    private var nicknameInputSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                TextField("이름", text: $settingNameViewModel.nickname)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .padding(.vertical, 12)
                    .padding(.horizontal, 12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(settingNameViewModel.borderColor, lineWidth: 1)
                    )
                Text(settingNameViewModel.statusMessage)
                    .foregroundColor(settingNameViewModel.statusColor)
                    .pretendardTextStyle(.Caption1Style)
                    .padding(.top, 2)
                    .padding(.leading, 2)
            }
            
            Button(action: settingNameViewModel.validateNickname) {
                Text("확인")
                    .pretendardTextStyle(.Title2Style)
                    .foregroundStyle(.black0)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(RoundedRectangle(cornerRadius: 8))
            }.padding(.top, -20)
        }
    }
    
    private var nextButton: some View {
        Button(action: {
            // 닉네임이 유효한 경우에만 다음 단계로 진행
            if settingNameViewModel.isNicknameValid {
                // 메인 뷰모델에 닉네임을 설정하고 다음 단계로 이동
                settingNameViewModel.setNickname(to: viewModel) {
                    viewModel.nextStep()
                }
            }
        }) {
            // 커스텀 버튼 디자인 적용
            DesignWideButton(
                label: "다음",
                // 닉네임 유효성에 따라 라벨 색상 변경
                labelColor: settingNameViewModel.isNicknameValid ? .blackAssets : .gray400,
                // 닉네임 유효성에 따라 버튼 배경색 변경
                btnBGColor: settingNameViewModel.isNicknameValid ? .lime : .gray600
            )
        }
        // 닉네임이 유효하지 않으면 버튼 비활성화
        .disabled(!settingNameViewModel.isNicknameValid)
    }
}

// 상단 표기
private var progressIndicator: some View {
    HStack(spacing: 10) {
        Spacer()
        CircleView(num: "1", numColor: .black, bgColor: .lime)
        CircleView(num: "2", numColor: .gray600, bgColor: .gray900)
    }
}

// CircleView
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
