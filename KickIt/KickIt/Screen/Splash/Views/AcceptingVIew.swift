//
//  AcceptingVIew.swift
//  KickIt
//
//  Created by DaeunLee on 9/13/24.
//

import SwiftUI

// 이용 약관 동의 화면
struct AcceptingView: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        ZStack(alignment: .top){
            // 배경화면 색 지정
            Color.background
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 16) {
                // 상단 텍스트
                headerSection
                
                // 동의 항목 섹션
                agreementSection
                
                Spacer()
                
                // 시작하기 버튼
                startButton
            }//:VSTACK
        }//:ZSTACK
        
    }
    
    // MARK: - View Components
    private var headerSection: some View {
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
    }
    
    private var agreementSection: some View {
        VStack {
            // 전체 동의 버튼
            HStack {
                Text("전체동의")
                    .pretendardTextStyle(.Title2Style)
                    .foregroundStyle(.white0)
                Spacer()
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(viewModel.acceptingViewModel.checkedAll ? .lime : .gray800)
                    .onTapGesture {
                        viewModel.acceptingViewModel.toggleAll()
                    }
            }
            
            Divider()
                .background(Color.gray900)
                .padding(.vertical, 10)
            
            // 개별 동의 항목
            VStack(alignment: .leading, spacing: 10) {
                agreementToggle(isOn: $viewModel.acceptingViewModel.agreeToTerms, title: "서비스 이용약관", isRequired: true)
                agreementToggle(isOn: $viewModel.acceptingViewModel.agreeToPrivacy, title: "개인정보 수집 및 이용 동의", isRequired: true)
                agreementToggle(isOn: $viewModel.acceptingViewModel.agreeToMarketing, title: "마케팅 정보 수신 동의", isRequired: false)
            }
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 12).foregroundStyle(.gray950))
        .padding(.horizontal, 16)
    }
    
    private func agreementToggle(isOn: Binding<Bool>, title: String, isRequired: Bool) -> some View {
        Toggle(isOn: isOn) {
            HStack(spacing: 7) {
                Text(isRequired ? "필수" : "선택")
                    .pretendardTextStyle(.Body2Style)
                    .foregroundStyle(isRequired ? .lime : .gray300)
                Text(title)
                    .pretendardTextStyle(.Body2Style)
                    .foregroundStyle(.white0)
                if isRequired {
                    Button(action: {
                        viewModel.acceptingViewModel.showModal = true
                    }) {
                        Image(systemName: "chevron.right")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 12, height: 12)
                            .foregroundStyle(.gray300)
                    }
                    .sheet(isPresented: $viewModel.acceptingViewModel.showModal) {
                        Text("\(title) 내용")
                    }
                }
                Spacer()
            }
        }
        .toggleStyle(CheckboxToggleStyle())
    }
    
    private var startButton: some View {
        Button(action: {
                    if viewModel.acceptingViewModel.canProceed {
                        viewModel.acceptingViewModel.setMarketingConsent(to: viewModel) { success in
                            if success {
                                // 홈으로 이동 또는 다음 단계 처리
                            } else {
                                // 에러 처리
                            }
                        }
                    }
                }) {
                    Text("시작하기")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.acceptingViewModel.canProceed ? Color.lime : Color.gray600)
                        .foregroundColor(viewModel.acceptingViewModel.canProceed ? .black : .gray400)
                        .cornerRadius(8)
                }
                .disabled(!viewModel.acceptingViewModel.canProceed)
    }
}

// 개별 항목 체크박스
struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            HStack {
                configuration.label
                Spacer()
                Image(systemName: "checkmark")
                    .foregroundColor(configuration.isOn ? .lime : .gray800)
            }
        }
    }
}

#Preview{
    AcceptingView(viewModel: MainViewModel())
}
