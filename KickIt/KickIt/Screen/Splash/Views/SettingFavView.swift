//
//  SettingFavView.swift
//  KickIt
//
//  Created by DaeunLee on 9/8/24.
//

import SwiftUI

// 팀 선택 화면
struct SettingFavView: View {
    @ObservedObject var viewModel: MainViewModel
    @ObservedObject var settingFavViewModel: SettingFavViewModel
    
    init(viewModel: MainViewModel) {
            self.viewModel = viewModel
            self.settingFavViewModel = viewModel.settingFavViewModel
        }
    
    var body: some View {
        ZStack(alignment: .top){
            // 배경화면 색 지정
            Color(.background)
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                HStack(spacing: 10) {
                    Spacer()
                    CircleView(num: "1", numColor: .gray600, bgColor: .gray900)
                    CircleView(num: "2", numColor: .black0, bgColor: .lime)
                }
                .padding(.horizontal, 24)
                .padding(.top, 10)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("프리미어 리그에서\n어떤 팀을 응원하시나요?")
                        .pretendardTextStyle(.H2Style)
                        .foregroundStyle(.white0)
                    HStack(spacing: 0){
                        Text("좋아하는 순서대로 ")
                            .pretendardTextStyle(.Body2Style)
                            .foregroundStyle(.gray500)
                        Text("최대 3개")
                            .pretendardTextStyle(.SubTitleStyle)
                            .foregroundStyle(.gray300)
                        Text("의 팀을 선택해주세요")
                            .pretendardTextStyle(.Body2Style)
                            .foregroundStyle(.gray500)
                    }
                    Text("경기 일정과 이벤트를 추천받을 수 있어요")
                        .pretendardTextStyle(.Body2Style)
                        .foregroundStyle(.gray500)
                    
                    
                }
                .padding(.leading, 16)
                .padding(.top, 50)
                .padding(.bottom, 36)
                
                ScrollView(.vertical, showsIndicators: false) {
                    // 프리미어리그 팀 전체
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                        ForEach(settingFavViewModel.teams.indices, id: \.self) { index in
                            teamSelectionButton(team: settingFavViewModel.teams[index], teamIndex: index)
                        }
                    }
                    .padding(.horizontal, 26)
                }
                
                Spacer()
                
                // 다음 버튼 활성화
                Button(action: {
                    if settingFavViewModel.selectedTeams.count >= 1 && settingFavViewModel.selectedTeams.count <= 3 {
                        settingFavViewModel.setFavoriteTeams(to: viewModel) {
                            viewModel.nextStep()
                        }
                    }
                }) {
                    DesignWideButton(
                        label: "다음",
                        labelColor: settingFavViewModel.selectedTeams.count >= 1 ? .blackAssets : .gray400,
                        btnBGColor: settingFavViewModel.selectedTeams.count >= 1 ? .lime : .gray600
                    ).padding()
                }
                .disabled(settingFavViewModel.selectedTeams.count < 1)
            }
        }.environment(\.colorScheme, .dark) // 무조건 다크모드
    }//:ZSTACK
    
    // 팀 선택 시 UI 변경 함수
    private func teamSelectionButton(team: SoccerTeam, teamIndex: Int) -> some View {
        RoundedRectangle(cornerRadius: 4)
            .stroke(settingFavViewModel.selectedTeams.contains(team.teamName) ? Color.lime : Color.gray900, lineWidth: 1)
            .frame(width: 100, height: 112, alignment: .center)
            .overlay(
                VStack {
                    AsyncImage(url: URL(string: team.teamEmblemURL)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                    Text(team.teamName)
                        .pretendardTextStyle(.Caption1Style)
                }
            )
            .overlay(
                Group {
                    if let index = settingFavViewModel.selectedTeams.firstIndex(of: team.teamName) {
                        CircleView(num: "\(index + 1)", numColor: .blackAssets, bgColor: .lime)
                            .frame(width: 18, height: 18)
                            .padding(9)
                    }
                },
                alignment: .topTrailing
            )
            .onTapGesture {
                settingFavViewModel.selectTeam(team)
            }
    }
}

#Preview{
    SettingFavView(viewModel: MainViewModel())
}
