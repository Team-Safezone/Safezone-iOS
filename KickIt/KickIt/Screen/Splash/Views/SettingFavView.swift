//
//  SettingFavView.swift
//  KickIt
//
//  Created by DaeunLee on 9/8/24.
//

import SwiftUI

// 팀 선택 화면
struct SettingFavView: View {
    @StateObject private var viewModel = SettingFavViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                // Progress Circles
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
            }
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                    ForEach(viewModel.teams.indices, id: \.self) { index in
                        teamSelectionButton(team: viewModel.teams[index], teamIndex: index)
                    }
                }
                .padding(.horizontal, 26)
            }
            
            Spacer()
            
            NavigationLink {
                AcceptingView()
            } label: {
                DesignWideButton(
                    label: "다음",
                    labelColor: viewModel.selectedTeams.count == 3 ? .background : .gray400,
                    btnBGColor: viewModel.selectedTeams.count == 3 ? .lime : .gray600
                )
                .disabled(viewModel.selectedTeams.count != 3)
            }//:NAVIGATIONVIEW
            .simultaneousGesture(TapGesture().onEnded {
                viewModel.setFavoriteTeams()
            })//:API 호출
        }//:NAVIGATIONSTACK
        .navigationBarBackButtonHidden(true)
    }
    
    private func teamSelectionButton(team: SoccerTeam, teamIndex: Int) -> some View {
        RoundedRectangle(cornerRadius: 4)
            .stroke(viewModel.selectedTeams.contains(teamIndex) ? Color.lime : Color.gray900, lineWidth: 1)
            .frame(width: 100, height: 112, alignment: .center)
            .overlay(
                VStack {
                    Image(team.teamEmblemURL)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                    Text(team.teamName)
                        .pretendardTextStyle(.Caption1Style)
                }
            )
            .overlay(
                viewModel.selectedTeams.contains(teamIndex) ? CircleView(num: "\(viewModel.selectedTeams.firstIndex(of: teamIndex)! + 1)", numColor: .black, bgColor: .lime).frame(width: 18, height: 18).padding(9) : nil,
                alignment: .topTrailing
            )
            .onTapGesture {
                viewModel.selectTeam(teamIndex)
            }
    }
}

#Preview {
    SettingFavView()
}
