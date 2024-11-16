//
//  ViewerStats.swift
//  KickIt
//
//  Created by DaeunLee on 7/29/24.
//

import SwiftUI

/// 심박수 통계 화면의 전체 시청자 분석 막대 그래프
struct ViewerStatsView: View {
    /// 홈팀 객체
    var homeTeam: SoccerTeam
    
    /// 원정팀 객체
    var awayTeam: SoccerTeam
    
    /// 홈팀 시청률 퍼센트율
    var homeTeamPercentage: Int
    
    var body: some View {
        VStack{
            HStack {
                Text("양 팀 시청자 분석")
                    .pretendardTextStyle(.Title1Style)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 30)
            
            HStack {
                HStack(spacing: 8) {
                    LoadableImage(image: homeTeam.teamEmblemURL)
                        .frame(width: 40, height: 40)
                        .background(.white)
                        .clipShape(Circle())
                    Text(homeTeam.teamName)
                        .pretendardTextStyle(.Body3Style)
                        .foregroundStyle(.gray200)
                }
                Spacer()
                HStack(spacing: 8) {
                    Text(awayTeam.teamName)
                        .pretendardTextStyle(.Body3Style)
                        .foregroundStyle(.gray200)
                    LoadableImage(image: awayTeam.teamEmblemURL)
                        .frame(width: 40, height: 40)
                        .background(.white)
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 20)
            
            ZStack(alignment: .trailing) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.green0)
                    .frame(maxWidth: .infinity, maxHeight: 10)
                RoundedRectangle(cornerRadius: 8)
                    .fill(.violet)
                    .frame(width: CGFloat(100 - homeTeamPercentage) * 375 / 100, height: 10)
            }
            .padding(.horizontal, 20)
            
            HStack {
                Text("\(Int(homeTeamPercentage))%")
                    .pretendardTextStyle(.Body1Style)
                    .foregroundStyle(.green0)
                Spacer()
                Text("\(Int(100 - homeTeamPercentage))%")
                    .pretendardTextStyle(.Body1Style)
                    .foregroundStyle(.violet)
            }
            .padding(.horizontal, 20)
        }.padding(.top, 40)
    }
}

#Preview {
    ViewerStatsView(homeTeam: dummySoccerTeams[0], awayTeam: dummySoccerTeams[1], homeTeamPercentage: 55)
}
