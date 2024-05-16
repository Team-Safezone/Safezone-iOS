//
//  SoccerMatchRow.swift
//  KickIt
//
//  Created by 이윤지 on 5/11/24.
//

import SwiftUI

/// 경기 일정 리스트 카드 뷰
struct SoccerMatchRow: View {
    /// 경기 객체
    @State var soccerMatch: SoccerMatch
    
    /// 경기 상태
    var matchStatus: String {
        switch (soccerMatch.matchCode) {
        case 0: "예정"
        case 1: "진행 중"
        case 2: "종료"
        default: "예정"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // MARK: - 경기 라운드
            Text("\(soccerMatch.matchRound)R - 경기 \(matchStatus)")
                .font(.footnote)
                .fontWeight(.medium)
                .foregroundStyle(.gray600)
            
            HStack(spacing: 0) {
                // MARK: - 홈 팀
                HStack(spacing: 0) {
                    // 팀 이름
                    Text("\(soccerMatch.homeTeam.teamName)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.gray600)
                        .padding(.trailing, 6)
                    
                    // 팀 로고 이미지
                    LoadableImage(image: "\(soccerMatch.homeTeam.teamImgURL)")
                        .frame(width: 36, height: 36)
                        .background(.white)
                        .clipShape(Circle())
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                // MARK: 경기 정보
                VStack(alignment: .center, spacing: 0) {
                    // MARK: - 예정, 진행 시간, 완료
                    Text("\(matchStatus)")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.gray600)
                    
                    // MARK: - 경기 예정 시간, 경기 스코어
                    switch (soccerMatch.matchCode) {
                    case 0:
                        Text("\(timeToString(time: soccerMatch.matchTime))")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                    case 1, 2:
                        HStack(spacing: 0) {
                            Text("\(soccerMatch.homeTeamScore?.description ?? "0")")
                                .font(.callout)
                                .fontWeight(.semibold)
                                .foregroundStyle(.black)
                            
                            Text(" - ")
                                .font(.callout)
                                .fontWeight(.semibold)
                                .foregroundStyle(.black)
                                .padding([.leading, .trailing], 12)
                            
                            Text("\(soccerMatch.awayTeamScore?.description ?? "0")")
                                .font(.callout)
                                .fontWeight(.semibold)
                                .foregroundStyle(.black)
                        }
                    default:
                        Text("\(timeToString(time: soccerMatch.matchTime))")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                    }
                }
                .frame(maxWidth: 90)
                
                // MARK: - 원정 팀
                HStack(spacing: 0) {
                    // 팀 로고 이미지
                    LoadableImage(image: "\(soccerMatch.awayTeam.teamImgURL)")
                        .frame(width: 36, height: 36)
                        .background(.white)
                        .clipShape(Circle())
                        .padding(.trailing, 6)
                    
                    // 팀 이름
                    Text("\(soccerMatch.awayTeam.teamName)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.gray600)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.top, 16)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding([.top, .leading, .trailing], 16)
        .padding(.bottom, 18)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.gray400, style: StrokeStyle(lineWidth: 1))
        )
    }
}

#Preview {
    SoccerMatchRow(soccerMatch: soccerMatches[5])
}
