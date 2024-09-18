//
//  AcceptingVIew.swift
//  KickIt
//
//  Created by DaeunLee on 9/13/24.
//

import SwiftUI

// 이용 약관 동의 화면
struct AcceptingView: View {
    @StateObject private var viewModel = AcceptingViewModel()
    @State private var navigateToHome = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("앱 이용을 위한\n이용 약관에 동의해주세요")
                            .pretendardTextStyle(.H2Style)
                        Text("약관을 클릭해 내용을 확인해주세요")
                            .pretendardTextStyle(.Body2Style)
                            .foregroundStyle(.gray500)
                    }
                    .padding(.leading, 16)
                    .padding(.top, 84)
                    .padding(.bottom, 36)
                    Spacer()
                }
                
                VStack {
                    HStack {
                        Text("전체동의")
                            .pretendardTextStyle(.Title2Style)
                            .foregroundStyle(.white0)
                        Spacer()
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(viewModel.checkedAll ? .lime : .gray800)
                            .onTapGesture {
                                viewModel.toggleAll()
                            }
                    }
                    
                    Rectangle()
                        .fill(Color.gray900)
                        .frame(height: 1)
                        .padding(.top, 14)
                        .padding(.bottom, 10)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        // 서비스 이용약관
                        Toggle(isOn: $viewModel.agreeToTerms) {
                            HStack(spacing: 7) {
                                Text("필수")
                                    .pretendardTextStyle(.Body2Style)
                                    .foregroundStyle(.lime)
                                Text("서비스 이용약관")
                                    .pretendardTextStyle(.Body2Style)
                                    .foregroundStyle(.white0)
                                Button(action: {
                                    viewModel.showModal = true
                                }) {
                                    Image(systemName: "chevron.right")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 12, height: 12)
                                        .foregroundStyle(.gray300)
                                }
                                .sheet(isPresented: $viewModel.showModal) {
                                    Text("서비스 이용약관 내용")
                                }
                                Spacer()
                            }
                        }
                        .toggleStyle(CheckboxToggleStyle())
                        
                        // 개인정보 수집 및 이용 동의
                        Toggle(isOn: $viewModel.agreeToPrivacy) {
                            HStack(spacing: 7) {
                                Text("필수")
                                    .pretendardTextStyle(.Body2Style)
                                    .foregroundStyle(.lime)
                                Text("개인정보 수집 및 이용 동의")
                                    .pretendardTextStyle(.Body2Style)
                                    .foregroundStyle(.white0)
                                Button(action: {
                                    viewModel.showModal = true
                                }) {
                                    Image(systemName: "chevron.right")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 12, height: 12)
                                        .foregroundStyle(.gray300)
                                }
                                Spacer()
                            }
                        }
                        .toggleStyle(CheckboxToggleStyle())
                        
                        // 마케팅 정보 수신 동의
                        Toggle(isOn: $viewModel.agreeToMarketing) {
                            HStack(spacing: 7) {
                                Text("선택")
                                    .pretendardTextStyle(.Body2Style)
                                    .foregroundStyle(.gray300)
                                Text("마케팅 정보 수신 동의")
                                    .pretendardTextStyle(.Body2Style)
                                    .foregroundStyle(.white0)
                                Spacer()
                            }
                        }
                        .toggleStyle(CheckboxToggleStyle())
                    }
                }
                .padding(20)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(.gray950)
                }
                .padding(.horizontal, 16)
                
                Spacer()
                
                // 시작하기 버튼
                Button(action: {
                    viewModel.setMarketingConsent {
                        // API 호출이 완료된 후 Home 화면으로 이동
                        navigateToHome = true
                    }
                }) {
                    DesignWideButton(
                        label: "시작하기",
                        labelColor: viewModel.canProceed ? .background : .gray400,
                        btnBGColor: viewModel.canProceed ? .lime : .gray600
                    )
                }
                .disabled(!viewModel.canProceed)
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $navigateToHome) {
                Home(soccerMatch: dummySoccerMatches[1])
            }
        }//:NAVIGATIONSTACK
    }
    
    // 체크박스 스타일 정의
    struct CheckboxToggleStyle: ToggleStyle {
        func makeBody(configuration: Configuration) -> some View {
            Button(action: {
                configuration.isOn.toggle()
            }) {
                HStack {
                    configuration.label
                    Spacer()
                    Image(systemName: configuration.isOn ? "checkmark" : "checkmark")
                        .foregroundColor(configuration.isOn ? Color.lime : Color.gray800)
                }
            }
        }
    }
}

#Preview {
    AcceptingView()
}
