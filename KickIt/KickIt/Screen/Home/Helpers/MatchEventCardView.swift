//
//  EventCardView.swift
//  KickIt
//
//  Created by 이윤지 on 9/26/24.
//

import SwiftUI

/// 홈 화면에서 사용되는 상단 경기 예측 카드 뷰
struct MatchEventCardView: View {
    /// 경기 객체
    var match: HomeMatch
    
    var body: some View {
        VStack(alignment: .leading) {
            // 예정 시간 및 획득할 수 있는 골 정보
            HStack(alignment: .center) {
                Text("\(match.matchDate) \(match.matchTime) 예정 경기")
                    .pretendardTextStyle(.Body1Style)
                    .foregroundStyle(.blackAssets)
                    .padding(.top, 4)
                
                Spacer()
                
                HStack(alignment: .center, spacing: 0) {
                    Image(uiImage: .coin)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    
                    HStack(alignment: .bottom, spacing: 0) {
                        Text("최대")
                            .pretendardTextStyle(.Caption1Style)
                        Text(" 4")
                            .pretendardTextStyle(.SubTitleStyle)
                        Text("골")
                            .pretendardTextStyle(.Caption1Style)
                    }
                    .foregroundStyle(.whiteAssets)
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(red: 50/255, green: 139/255, blue: 107/255))
                )
            }
            
            // 경기 정보
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("\(match.homeTeam.teamName) VS \(match.awayTeam.teamName)")
                    
                    Text("경기 예측하기")
                }
                .pretendardTextStyle(TextStyle(font: .H1, tracking: -0.6, uiFont: UIFont(name: "Pretendard-Bold", size: 24)!, lineHeight: 30))
                .foregroundStyle(.whiteAssets)
                .padding(.bottom, 11)
                
                Spacer()
                
                HStack(spacing: 12) {
                    LoadableImage(image: match.homeTeam.teamEmblemURL)
                        .frame(width: 60, height: 60)
                        .emblemShadow()
                        .padding(.bottom, 17)
                    
                    LoadableImage(image: match.awayTeam.teamEmblemURL)
                        .frame(width: 60, height: 60)
                        .emblemShadow()
                        .padding(.top, 19)
                }
                .padding(.trailing, 12)
            }
        }
        .padding(12)
        .background(
            Image(uiImage: .matchBanner)
                .resizable()
        )
    }
}

#Preview {
    MatchEventCardView(match: HomeMatch(matchId: 0, matchDate: "2024.09.09", matchTime: "20:32", homeTeam: dummySoccerTeams[2], awayTeam: dummySoccerTeams[4]))
}
