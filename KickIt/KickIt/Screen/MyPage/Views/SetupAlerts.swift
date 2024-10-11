//
//  AddingAlerts.swift
//  KickIt
//
//  Created by DaeunLee on 10/10/24.
//

import SwiftUI

// 알림 설정 화면
struct SetupAlerts: View {
    @StateObject private var viewModel = SetupAlertsViewModel()
    
    var body: some View {
        ZStack{
            Color.background
                .ignoresSafeArea()
            VStack(alignment: .leading){
                TextView(text1: "서비스 알림", text2: "선택한 알림만 보내드릴게요")
                    .padding(.horizontal, 16)
                Divider().padding()
                HStack{
                    TextView(text1: "경기 시작", text2: "설정된 My 팀의 경기 시작 전 알림")
                    Toggle("", isOn: $viewModel.isGameStartAlertOn)
                        .toggleStyle(SwitchToggleStyle(tint: .lime))
                        .onChange(of: viewModel.isGameStartAlertOn) {
                            viewModel.toggleGameStartAlert()
                        }
                }.padding(.horizontal, 16)
                HStack{
                    TextView(text1: "선발 라인업", text2: "설정된 My 팀의 선발 라인업 공개 알림")
                    Toggle("", isOn: $viewModel.isLineupAlertOn)
                        .toggleStyle(SwitchToggleStyle(tint: .lime))
                        .onChange(of: viewModel.isLineupAlertOn) {
                            viewModel.toggleLineupAlert()
                        }
                }.padding(.horizontal, 16).padding(.top, 24)
                Spacer()
            }//:VSTACK
            .padding(.top, 24)
        }.navigationTitle("알림 설정")
    }
}

#Preview {
    SetupAlerts()
}

// 화면 2줄 텍스트뷰
struct TextView: View {
    var text1: String
    var text2: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8){
            Text(text1)
                .foregroundStyle(.white0)
                .font(.pretendard(.bold, size: 16))
            Text(text2)
                .foregroundStyle(.gray500Text)
                .font(.pretendard(.medium, size: 14))
                .frame(minWidth: 210, alignment: .leading)
        }
    }
}
