//
//  MatchCardView.swift
//  KickIt
//
//  Created by 이윤지 on 9/27/24.
//

import SwiftUI

/// 홈 화면에서 사용하는 경기 일정 카드 뷰
struct MatchCardView: View {
    /// 경기 객체
    var soccerMatch: SoccerMatch
    
    var body: some View {
        HStack(spacing: 30) {
            Spacer()
            
            // MARK: 홈팀
            VStack(spacing: 4) {
                LoadableImage(image: "\(soccerMatch.homeTeam.teamEmblemURL)")
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                Text("\(soccerMatch.homeTeam.teamName)")
                    .pretendardTextStyle(.Body3Style)
                    .foregroundStyle(.gray200Assets)
            }
            .frame(width: 80)
            
            VStack(alignment: .center, spacing: 5) {
                Text("\(dateToString2(date: soccerMatch.matchDate))")
                    .pretendardTextStyle(.Body3Style)
                    .foregroundStyle(.white0)
                Text("\(timeToString(time: soccerMatch.matchTime))")
                    .font(.pretendard(.bold, size: 18))
                    .foregroundStyle(.white0)
            }
            
            // MARK: 원정팀
            VStack(spacing: 4) {
                LoadableImage(image: "\(soccerMatch.awayTeam.teamEmblemURL)")
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                Text("\(soccerMatch.awayTeam.teamName)")
                    .pretendardTextStyle(.Body3Style)
                    .foregroundStyle(.gray200Assets)
            }
            .frame(width: 80)
            
            Spacer()
        }
        .padding(.vertical, 12)
        .background{
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray950)
        }
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 0)
    }
}

#Preview {
    MatchCardView(soccerMatch: dummySoccerMatches[0])
}
