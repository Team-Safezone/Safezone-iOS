//
//  EditMyTeams.swift
//  KickIt
//
//  Created by DaeunLee on 10/10/24.
//

import SwiftUI

// My 팀 수정 화면
struct EditMyTeams: View {
    @ObservedObject var viewModel: EditMyTeamsViewModel
    @Environment(\.presentationMode) var presentationMode // 이전 화면 이동
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            VStack(alignment: .leading){
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        Text("좋아하는 순서대로 ")
                            .pretendardTextStyle(.Body2Style)
                            .foregroundStyle(.gray300)
                        Text("최대 3개")
                            .pretendardTextStyle(.SubTitleStyle)
                            .foregroundStyle(.white0)
                        Text("의 팀을 선택해주세요")
                            .pretendardTextStyle(.Body2Style)
                            .foregroundStyle(.gray300)
                    }
                    Text("경기 일정과 이벤트를 추천받을 수 있어요")
                        .pretendardTextStyle(.Body2Style)
                        .foregroundStyle(.gray300)
                }
                .padding(.leading, 16)
                .padding(.top, 20)
                .padding(.bottom, 24)
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                        ForEach(viewModel.teams.indices, id: \.self) { index in
                            teamSelectionButton(team: viewModel.teams[index], teamIndex: index)
                        }
                    }
                    .padding(.bottom, 120)
                }
                .padding(.horizontal, 26)
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationTitle("내가 응원하는 팀")
        .navigationBarItems(trailing:
            Button("수정") {
            viewModel.setFavoriteTeams()    // API 호출
            presentationMode.wrappedValue.dismiss() // 이전 화면
        }
            .foregroundStyle(.limeText)
            .pretendardTextStyle(.Title2Style)
            // 팀 하나 이상 클릭 시에만 수정 버튼 동작
            .disabled(viewModel.selectedTeams.count < 1)
        )
    }
    
    // 팀 선택 시 UI 변경 함수
    private func teamSelectionButton(team: SoccerTeam, teamIndex: Int) -> some View {
        RoundedRectangle(cornerRadius: 4)
            .stroke(viewModel.selectedTeams.contains(team.teamName) ? Color.lime : Color.gray900, lineWidth: 1)
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
                    if let index = viewModel.selectedTeams.firstIndex(of: team.teamName) {
                        CircleView(num: "\(index + 1)", numColor: .blackAssets, bgColor: .lime)
                            .frame(width: 18, height: 18)
                            .padding(9)
                    }
                },
                alignment: .topTrailing
            )
            .onTapGesture {
                viewModel.selectTeam(team)
            }
    }
}

#Preview {
    EditMyTeams(viewModel: EditMyTeamsViewModel())
}
