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
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 10) {
                Spacer()
                CircleView(num: "1", numColor: .gray600, bgColor: .gray900)
                CircleView(num: "2", numColor: .black, bgColor: .lime)
            }
            .padding(.horizontal, 24)
            .padding(.top, 10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("프리미어 리그에서\n어떤 팀을 응원하시나요?")
                    .pretendardTextStyle(.H2Style)
                Text("좋아하는 순서대로 최대 3개의 팀을 선택해주세요!")
                    .pretendardTextStyle(.Body2Style)
                    .foregroundStyle(.gray500)
            }
            .padding(.leading, 16)
            .padding(.top, 50)
            .padding(.bottom, 36)
            
            ScrollView(.vertical, showsIndicators: false) {
                // 프리미어리그 팀 전체
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                    ForEach(viewModel.settingFavViewModel.teams.indices, id: \.self) { index in
                        teamSelectionButton(team: viewModel.settingFavViewModel.teams[index], teamIndex: index)
                    }
                }
                .padding(.horizontal, 26)
            }
            
            Spacer()
            
            // 선택이 3개일 때 다음 버튼 활성화
            Button(action: {
                if viewModel.settingFavViewModel.selectedTeams.count == 3 {
                    viewModel.settingFavViewModel.setFavoriteTeams {
                        viewModel.nextStep()
                    }
                }
            }) {
                DesignWideButton(
                    label: "다음",
                    labelColor: viewModel.settingFavViewModel.selectedTeams.count == 3 ? .background : .gray400,
                    btnBGColor: viewModel.settingFavViewModel.selectedTeams.count == 3 ? .lime : .gray600
                )
            }
            .disabled(viewModel.settingFavViewModel.selectedTeams.count != 3)
        }
    }
    
    // 팀 선택 시 UI 변경 함수
    private func teamSelectionButton(team: SoccerTeam, teamIndex: Int) -> some View {
        RoundedRectangle(cornerRadius: 4)
            .stroke(viewModel.settingFavViewModel.selectedTeams.contains(teamIndex) ? Color.lime : Color.gray900, lineWidth: 1)
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
                viewModel.settingFavViewModel.selectedTeams.contains(teamIndex) ? CircleView(num: "\(viewModel.settingFavViewModel.selectedTeams.firstIndex(of: teamIndex)! + 1)", numColor: .black, bgColor: .lime).frame(width: 18, height: 18).padding(9) : nil,
                alignment: .topTrailing
            )
            .onTapGesture {
                viewModel.settingFavViewModel.selectTeam(teamIndex)
            }
    }
}

#Preview{
    SettingFavView(viewModel: MainViewModel())
}
