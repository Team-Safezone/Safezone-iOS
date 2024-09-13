//
//  AcceptingVIew.swift
//  KickIt
//
//  Created by DaeunLee on 9/13/24.
//

import SwiftUI

struct AcceptingView: View {
    // 동의 항목 상태 변수
    @State private var CheckedAll = false
    @State private var agreeToTerms = false
    @State private var agreeToPrivacy = false
    @State private var agreeToMarketing = false
    @State private var showModal = false
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading, spacing: 16) {
                HStack{
                    VStack(alignment: .leading, spacing: 4) {
                        Text("앱 이용을 위한\n이용 약관에 동의해주세요")
                            .pretendardTextStyle(.H2Style)
                        Text("약관을 클릭해 내용을 확인해주세요")
                            .pretendardTextStyle(.Body2Style)
                            .foregroundStyle(.gray500)
                    } //:VSTACK
                    .padding(.leading, 16)
                    .padding(.top, 84)
                    .padding(.bottom, 36)
                    Spacer()
                }
                
                VStack {
                    HStack {
                        Text("전체동의")
                            .pretendardTextStyle(.Title2Style)
                            .foregroundStyle(.black0)
                        Spacer()
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(CheckedAll ? .lime : .gray800)
                            .onTapGesture {
                                CheckedAll.toggle()
                                agreeToTerms = CheckedAll
                                agreeToPrivacy = CheckedAll
                                agreeToMarketing = CheckedAll
                            }
                    } //: HSTACK
                    .padding(.trailing, 10)
                    
                    Rectangle()
                        .fill(Color.gray900)
                        .frame(height: 1)
                        .padding(.top, 14)
                        .padding(.bottom, 10)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Toggle(isOn: $agreeToTerms) {
                                HStack(spacing: 7) {
                                    Text("필수")
                                        .pretendardTextStyle(.Body2Style)
                                        .foregroundStyle(.lime)
                                    Text("서비스 이용약관")
                                        .pretendardTextStyle(.Body2Style)
                                        .foregroundStyle(.black0)
                                    Button(action: {
                                        showModal = true
                                    }) {
                                        Image(systemName: "chevron.right")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 12, height: 12)
                                            .foregroundStyle(.gray300)
                                    }
                                    .sheet(isPresented: $showModal) {
                                        Text("서비스 이용약관 내용")
                                    }
                                    Spacer()
                                } //: HSTACK
                            }
                            Spacer()
                        }
                        .toggleStyle(CheckboxToggleStyle())
                        
                        HStack {
                            Toggle(isOn: $agreeToPrivacy) {
                                HStack(spacing: 7) {
                                    Text("필수")
                                        .pretendardTextStyle(.Body2Style)
                                        .foregroundStyle(.lime)
                                    Text("개인정보 수집 및 이용 동의")
                                        .pretendardTextStyle(.Body2Style)
                                        .foregroundStyle(.black0)
                                    Button(action: {
                                        showModal = true
                                    }) {
                                        Image(systemName: "chevron.right")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 12, height: 12)
                                            .foregroundStyle(.gray300)
                                    }
                                    Spacer()
                                } //: HSTACK
                            }
                            Spacer()
                        }
                        .toggleStyle(CheckboxToggleStyle())
                        
                        HStack {
                            Toggle(isOn: $agreeToMarketing) {
                                HStack(spacing: 7) {
                                    Text("선택")
                                        .pretendardTextStyle(.Body2Style)
                                        .foregroundStyle(.gray300)
                                    Text("마케팅 정보 수신 동의")
                                        .pretendardTextStyle(.Body2Style)
                                        .foregroundStyle(.black0)
                                    Spacer()
                                } //: HSTACK
                            }
                            Spacer()
                        }
                        .toggleStyle(CheckboxToggleStyle())
                    } //: VSTACK
                } //: VSTACK
                .padding(20)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(.gray950)
                }
                .padding(.horizontal, 16)
                
                Spacer()
                
                NavigationLink {
                    Home(soccerMatch: dummySoccerMatches[1])
                } label: {
                    DesignWideButton(
                        label: "시작하기",
                        labelColor: (agreeToTerms && agreeToPrivacy) ? .background : .gray400,
                        btnBGColor: (agreeToTerms && agreeToPrivacy) ? .lime : .gray600
                    )
                }
                .disabled(!(agreeToTerms && agreeToPrivacy))
            }
            .navigationBarBackButtonHidden(true)
        }
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
