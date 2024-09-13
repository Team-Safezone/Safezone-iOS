//
//  SettingFavView.swift
//  KickIt
//
//  Created by DaeunLee on 9/8/24.
//

import SwiftUI

struct SettingFavView: View {
    @State private var selectedTeams: [Int] = []
    
    let teams = [
        ("노팅엄 포레스트", "nottingham_forest_logo"),
        ("뉴캐슬", "newcastle_logo"),
        ("레스터 시티", "leicester_logo"),
        ("리버풀", "liverpool_logo"),
        ("뉴캐슬", "newcastle_logo"),
        ("레스터 시티", "leicester_logo"),
        ("리버풀", "liverpool_logo"),
        ("뉴캐슬", "newcastle_logo"),
        ("레스터 시티", "leicester_logo"),
        ("리버풀", "liverpool_logo"),
        ("리버풀", "liverpool_logo"),
        ("뉴캐슬", "newcastle_logo"),
        ("레스터 시티", "leicester_logo"),
        ("리버풀", "liverpool_logo")
        
    ]
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading) {
                // 상단 Progress Circle
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
                } //:VSTACK
                .padding(.leading, 16)
                .padding(.top, 50)
                .padding(.bottom, 36)
            }//:VSTACK
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 3), spacing: 16) {
                    ForEach(teams.indices, id: \.self) { index in
                        teamSelectionButton(teamName: teams[index].0, teamImage: teams[index].1, teamIndex: index)
                    }//:FOREACH
                }//:LAZYVGRID
                .padding(.horizontal, 26)
                .padding(.top, 2)
            }//:SCROLLVIEW
            
            Spacer()
            
            NavigationLink{
                AcceptingView()
            } label:{
                DesignWideButton(
                    label: "다음",
                    labelColor: selectedTeams.count == 3 ? .background : .gray400,
                    btnBGColor: selectedTeams.count == 3 ? .lime : .gray600
                )
                .disabled(selectedTeams.count != 3)
            }//:NAVIGATIONLINK
            
        }//:NAVIGATIONSTACK
        .navigationBarBackButtonHidden(true)
    }
    
    // 팀 버튼
    private func teamSelectionButton(teamName: String, teamImage: String, teamIndex: Int) -> some View {
        RoundedRectangle(cornerRadius: 4)
            .stroke(selectedTeams.contains(teamIndex) ? Color.lime : Color.gray900, lineWidth: 1) // 변경된 부분
            .foregroundStyle(.clear)
            .frame(width: 100, height: 112, alignment: .center)
            .overlay(
                VStack {
                    Image(teamImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                    Text(teamName)
                        .pretendardTextStyle(.Caption1Style)
                }
            )
            .overlay(
                selectedTeams.contains(teamIndex) ? CircleView(num: "\(selectedTeams.firstIndex(of: teamIndex)! + 1)", numColor: .black, bgColor: .lime).frame(width: 18, height: 18).padding(9) : nil,
                alignment: .topTrailing
            )
            .onTapGesture {
                selectTeam(teamIndex)
            }
    }
    
    // 팀 선택 함수
    private func selectTeam(_ teamIndex: Int) {
        if let index = selectedTeams.firstIndex(of: teamIndex) {
            // 팀 선택 취소
            selectedTeams.remove(at: index)
        } else if selectedTeams.count < 3 {
            // 팀 선택
            selectedTeams.append(teamIndex)
        }
    }
}

#Preview {
    SettingFavView()
}
