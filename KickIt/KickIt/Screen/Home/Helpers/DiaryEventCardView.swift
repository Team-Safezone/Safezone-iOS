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
                        Text(" 2")
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
                        .fill(Color(red: 215/255, green: 96/255, blue: 100/255))
                )
            }
            
            // 경기 정보
            HStack(alignment: .center, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("\(match.homeTeam.teamName) VS \(match.awayTeam.teamName)")
                    
                    Text("축구 일기쓰기")
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
            Image(uiImage: .diaryBanner)
                .resizable()
        )
    }
}

#Preview {
    DiaryEventCardView(match: HomeDiary(diaryId: 0, matchDate: "2024.09.09", matchTime: "20:32", homeTeam: dummySoccerTeams[1], awayTeam: dummySoccerTeams[3]))
}
