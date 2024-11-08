//
//  MyProfile.swift
//  KickIt
//
//  Created by DaeunLee on 10/10/24.
//

import SwiftUI

// 프로필 설정 화면
struct MyProfile: View {
    @ObservedObject var viewModel: MyProfileViewModel
    @StateObject private var imgviewModel = MyPageViewModel()
    @Environment(\.presentationMode) var presentationMode // 이전 화면 이동
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack(alignment: .center) {
                            Image("ball\(imgviewModel.getIndexForBallLevel(imgviewModel.currentBallLevel.name)!)")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120, alignment: .center)
                                .padding(.bottom, 8)
                            NavigationLink(destination: GradeInfo().toolbarRole(.editor)) {
                                HStack(spacing: 2) {
                                    Text("등급 안내")
                                        .pretendardTextStyle(.Body2Style)
                                        .foregroundStyle(.white0)
                                    Image("CaretRight")
                                        .frame(width: 18, height: 18, alignment: .center)
                                        .foregroundStyle(.gray500Text)
                                }.padding(.vertical, 6)
                                    .padding(.trailing, 8)
                                    .padding(.leading, 15)
                                    .background {
                                        RoundedRectangle(cornerRadius: 30)
                                            .foregroundStyle(.gray900Assets)
                                    }
                            }
                        }
                        Spacer()
                    }
                    .padding(.bottom, 50)
                    
                    // 닉네임 수정
                    VStack(alignment: .leading) {
                        HStack {
                            Text("닉네임")
                                .pretendardTextStyle(.Title2Style)
                            Spacer()
                        }
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                TextField("닉네임", text: $viewModel.nickname)
                                    .textFieldStyle(DefaultTextFieldStyle())
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(viewModel.borderColor, lineWidth: 1)
                                    )
                                Text(viewModel.statusMessage)
                                    .foregroundColor(viewModel.statusColor)
                                    .pretendardTextStyle(.Caption1Style)
                                    .padding(.top, 2)
                                    .padding(.leading, 2)
                            }
                            
                            Button(action: viewModel.validateNickname) {
                                Text("수정")
                                    .pretendardTextStyle(.Title2Style)
                                    .foregroundStyle(.blackAssets)
                                    .padding(.horizontal, 30)
                                    .padding(.vertical, 12)
                                    .background(RoundedRectangle(cornerRadius: 8))
                            }.foregroundStyle(.accent).padding(.top, -20)
                        }
                    }
                    .padding(.horizontal, 24)
                    Spacer()
                    
                    // 닉네임 수정 버튼
                    Button(action: {
                        viewModel.validateNickname()
                        // 유효한 닉네임일 때만 닉네임 수정
                        if viewModel.isNicknameValid {
                            viewModel.setNickname()
                            viewModel.showChangeSuccess = true
        
                            // 3초 후에 ChangeSuccessView 숨김
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                viewModel.showChangeSuccess = false
                                presentationMode.wrappedValue.dismiss() // 이전 화면
                            }
                        }
                    }, label: {
                        DesignWideButton(label: "닉네임 중복 확인이 필요합니다", labelColor: .white0, btnBGColor: .gray900Assets)
                            .padding()
                    })
                }
                
                // 닉네임 변경 성공
                if viewModel.showChangeSuccess {
                    VStack {
                        Spacer()
                        ChangeSuccessView()
                            .transition(.move(edge: .bottom))
                            .animation(.easeInOut(duration: 3), value: viewModel.showChangeSuccess)
                            .padding(.bottom, 70)
                    }
                }
            }
        }
        .navigationTitle("나의 프로필")
    }
}

#Preview {
    MyProfile(viewModel: MyProfileViewModel())
}

// Toast Msg
struct ChangeSuccessView: View {
    var body: some View {
        HStack(spacing: 4){
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 18, height: 18)
                .foregroundStyle(.lime)
            Text("닉네임 변경 완료")
                .pretendardTextStyle(.SubTitleStyle)
                .foregroundStyle(.whiteAssets)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background{
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(.gray800Assets)
        }
        .padding()
    }
}
