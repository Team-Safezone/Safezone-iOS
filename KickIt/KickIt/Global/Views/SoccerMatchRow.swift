//
//  SoccerMatchRow.swift
//  KickIt
//
//  Created by 이윤지 on 5/11/24.
//

import SwiftUI

/// 경기 일정 리스트 카드 뷰
struct SoccerMatchRow: View {
    
    /// 축구 경기 객체
    var soccerMatch: SoccerMatch
    
    /// 경기 상태, 라벨 배경 색상, 라벨 색상
    func matchStatus() -> (String, Color, Color) {
        switch (soccerMatch.matchCode) {
        case 0: ("예정", Color.whiteText, Color.blackAssets)
        case 1: ("경기중", Color.lime, Color.blackAssets)
        //case 2: ("휴식", Color.gray800, Color.white)
        case 3: ("종료", Color.gray800Assets, Color.whiteAssets)
        case 4: ("연기", Color.gray800Assets, Color.gray300Assets)
        default: ("예정", Color.whiteText, Color.blackAssets)
        }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            // MARK: - 홈 팀
            HStack(spacing: 20) {
                VStack(spacing: 4) {
                    // 홈 팀 엠블럼
                    LoadableImage(image: soccerMatch.homeTeam.teamEmblemURL)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    
                    // 홈 팀 이름
                    Text(soccerMatch.homeTeam.teamName)
                        .pretendardTextStyle(.Body3Style)
                        .foregroundStyle(.gray200Assets)
                        .frame(width: 80)
                }
                
                // 홈 팀 점수
                Text(soccerMatch.homeTeamScore?.description ?? "-")
                    .pretendardTextStyle(.H2Style)
                    .foregroundStyle(.white0)
                    .frame(width: 20)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            
            // MARK: - 경기 정보
            VStack(alignment: .center, spacing: 5) {
                // MARK: 경기 상태
                Text("\(matchStatus().0)")
                    .pretendardTextStyle(.Caption1Style)
                    .padding(.vertical, 2)
                    .padding(.horizontal, 12)
                    .foregroundStyle(matchStatus().2)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(matchStatus().1)
                    )
                
                // MARK: 경기 예정 시간
                Text("\(timeToString(time: soccerMatch.matchTime))")
                    .pretendardTextStyle(.Title1Style)
                    .foregroundStyle(.white0)
            }
            .padding(.horizontal, soccerMatch.matchCode != 1 ? 18 : 13.5)
            
            // MARK: - 원정 팀
            HStack(spacing: 20) {
                // 원정 팀 점수
                Text(soccerMatch.awayTeamScore?.description ?? "-")
                    .pretendardTextStyle(.H2Style)
                    .foregroundStyle(.white0)
                    .frame(width: 20)
                
                VStack(spacing: 4) {
                    // 원정 팀 엠블럼
                    LoadableImage(image: soccerMatch.awayTeam.teamEmblemURL)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    
                    // 원정 팀 이름
                    Text(soccerMatch.awayTeam.teamName)
                        .pretendardTextStyle(.Body3Style)
                        .foregroundStyle(.gray200Assets)
                        .frame(width: 80)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, 12)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.gray950)
                .cardShadow()
        )
    }
}

#Preview {
    SoccerMatchRow(soccerMatch: dummySoccerMatches[1])
}
