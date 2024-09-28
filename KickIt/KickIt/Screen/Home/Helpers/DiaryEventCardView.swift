//
//  DiaryEventCardView.swift
//  KickIt
//
//  Created by 이윤지 on 9/27/24.
//

import SwiftUI

/// 홈 화면에서 사용되는 상단 일기 쓰기 카드 뷰
struct DiaryEventCardView: View {
    /// 경기 객체
    var match: HomeDiary
    
    var body: some View {
        VStack(alignment: .leading) {
            // 예정 시간 및 획득할 수 있는 골 정보
            HStack(alignment: .center) {
                Text("\(match.matchDate) \(match.matchTime)에 본 경기")
                    .pretendardTextStyle(.SubTitleStyle)
                    .foregroundStyle(.blackAssets)
                
                Spacer()
                
                HStack(alignment: .center, spacing: 0) {
                    Image(uiImage: .coin)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    Text(" 2")
                        .pretendardTextStyle(.SubTitleStyle)
                    Text("골")
                        .pretendardTextStyle(.Caption1Style)
                }
                .foregroundStyle(.whiteAssets)
                .padding(.horizontal, 6)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(red: 215/255, green: 96/255, blue: 100/255))
                )
            }
            
            // 경기 정보
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("\(match.homeTeam.teamName) VS \(match.awayTeam.teamName)")
                        .pretendardTextStyle(.H2Style)
                        .foregroundStyle(.whiteAssets)
                    
                    Text("경기 예측하기")
                        .pretendardTextStyle(.H2Style)
                        .foregroundStyle(.whiteAssets)
                }
                
                Spacer()
                
                // FIXME: 엠블럼 이미지 받아온 걸로 수정하기!
                HStack(spacing: 12) {
                    Image(uiImage: .city)
                        .frame(width: 50, height: 50)
                        .padding(.bottom, 17)
                        .shadow(color: .black.opacity(0.15), radius: 2, x: 3, y: 3)
                    
                    Image(uiImage: .switch)
                        .frame(width: 50, height: 50)
                        .padding(.top, 19)
                        .shadow(color: .black.opacity(0.15), radius: 2, x: 3, y: 3)
                }
                .padding(.trailing, 12)
            }
        }
        .padding(12)
        .background(
            Image(uiImage: .diaryBanner)
                .resizable()
                .scaledToFill()
        )
    }
}

#Preview {
    DiaryEventCardView(match: HomeDiary(diaryId: 0, matchDate: "2024.09.09", matchTime: "20:32", homeTeam: dummySoccerTeams[0], awayTeam: dummySoccerTeams[1]))
}
