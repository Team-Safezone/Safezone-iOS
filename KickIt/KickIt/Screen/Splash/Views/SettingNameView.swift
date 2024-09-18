//
//  SettingNameView.swift
//  KickIt
//
//  Created by DaeunLee on 9/8/24.
//

import SwiftUI

// 닉네임 설정 화면
struct SettingNameView: View {
    @StateObject private var viewModel = SettingNameViewModel()
    @State private var navigateToSettingFav = false
    
    var body: some View {
        NavigationStack {
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
                } //:VSTACK
                .padding(.leading, 16)
                .padding(.top, 50)
                .padding(.bottom, 36)
                
                VStack(alignment: .leading, spacing: 4) {
                    TextField("이름", text: $viewModel.nickname)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .padding(.leading, 12)
                        .padding(.vertical, 15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(viewModel.borderColor, lineWidth: 1)
                        )
                    
                    Text(viewModel.statusMessage)
                        .foregroundColor(viewModel.statusColor)
                        .pretendardTextStyle(.Caption1Style)
                        .padding(.leading, 4)
                }//:VSTACK
                .padding(.horizontal, 24)
                
            }//:VSTACK
            Spacer()
            
            Button(action: {
                            if viewModel.isNicknameValid {
                                viewModel.setNickname {
                                    navigateToSettingFav = true
                                }
                            }
                        }) {
                            DesignWideButton(
                                label: "다음",
                                labelColor: viewModel.isNicknameValid ? .background : .gray400,
                                btnBGColor: viewModel.isNicknameValid ? .lime : .gray600
                            )
                        }
                        .disabled(!viewModel.isNicknameValid)
                    }
                    .navigationBarBackButtonHidden(true)
                    .navigationDestination(isPresented: $navigateToSettingFav) {
                        SettingFavView()
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
