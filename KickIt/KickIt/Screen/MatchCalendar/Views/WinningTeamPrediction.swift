//
//  WinningTeamPrediction.swift
//  KickIt
//
//  Created by 이윤지 on 5/26/24.
//

import Charts
import SwiftUI

/// 우승팀 예측 화면
// TODO: MVVM으로 수정 필요
struct WinningTeamPrediction: View {
    /// 축구 경기 객체
    var soccerMatch: SoccerMatch
    
    /// 홈팀의 예상 골 개수
    @State private var homeTeamGoal = 0
    
    /// 원정팀의 예상 골 개수
    @State private var awayTeamGoal = 0
    
    var body: some View {
        ZStack {
            Color(.background)
            VStack(alignment: .leading, spacing: 0) {
                // MARK: - 상단 박스
                VStack(alignment: .leading, spacing: 0) {
                    Text("Q. 우승 팀 예측")
                        .pretendardTextStyle(.SubTitleStyle)
                        .foregroundStyle(.lime)
                    
                    Text("\(soccerMatch.homeTeam.teamName) vs \(soccerMatch.awayTeam.teamName) 이번 경기에서 몇 골을 넣을까?")
                        .pretendardTextStyle(.Title1Style)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 4)
                    
                    HStack(spacing: 4) {
                        Text("예측 종료까지")
                            .pretendardTextStyle(.Caption1Style)
                            .foregroundStyle(.gray300)
                        
//                        Text("\(timePredictionInterval(nowDate: nowDate, matchDate: soccerMatch.matchDate, matchTime: soccerMatch.matchTime))")
//                            .pretendardTextStyle(.Caption1Style)
//                            .foregroundStyle(.white)
                    }
                    .padding(.top, 10)
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray950)
                )
                .padding(.horizontal, 16)
                .padding(.top, 12)
                
                // MARK: - 팀 정보
                HStack(alignment: .center) {
                    // MARK: 홈 팀
                    VStack(alignment: .center, spacing: 0) {
                        // 홈 팀 엠블럼 이미지
                        LoadableImage(image: soccerMatch.homeTeam.teamEmblemURL)
                            .frame(width: 88, height: 88)
                            .clipShape(Circle())
                        
                        HStack(spacing: 0) {
                            Image(systemName: "house.fill")
                                .foregroundStyle(.gray500)
                                .font(.system(size: 15))
                            
                            // 팀 명
                            Text("\(soccerMatch.homeTeam.teamName)")
                                .pretendardTextStyle(.Body1Style)
                                .foregroundStyle(.white)
                        }
                        .padding(.top, 8)
                        .frame(width: 88, alignment: .center)
                    }
                    
                    Spacer()
                    
                    // MARK: 원정 팀
                    VStack(alignment: .center, spacing: 0) {
                        // 원정 팀 엠블럼 이미지
                        LoadableImage(image: soccerMatch.awayTeam.teamEmblemURL)
                            .frame(width: 88, height: 88)
                            .clipShape(Circle())
                            
                            // 팀 명
                            Text("\(soccerMatch.awayTeam.teamName)")
                                .pretendardTextStyle(.Body1Style)
                                .foregroundStyle(.white)
                                .padding(.top, 8)
                        }
                        .frame(width: 88, alignment: .center)
                }
                .padding(.horizontal, 50)
                .padding(.top, 72)
                
                // MARK: - 골 예측
                HStack(alignment: .center) {
                    // MARK: 홈팀의 골 예측
                    VStack(spacing: 16) {
                        // 홈팀 예상 골 개수 추가
                        Button {
                            if (homeTeamGoal < 10) {
                                homeTeamGoal += 1
                            }
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 24))
                                .frame(width: 24, height: 24)
                                .foregroundStyle(.white)
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(.gray950)
                                )
                        }
                        
                        // 홈팀의 예상 골 개수
                        HStack(spacing: 8) {
                            Text("\(homeTeamGoal)")
                                .pretendardTextStyle(.H1Style)
                                .foregroundStyle(.lime)
                                .frame(width: 30)
                            
                            Text("골")
                                .pretendardTextStyle(.Body1Style)
                                .foregroundStyle(.gray200)
                                .frame(width: 30)
                        }
                        
                        // 홈팀 예상 골 개수 삭제
                        Button {
                            if (homeTeamGoal > 0) {
                                homeTeamGoal -= 1
                            }
                        } label: {
                            Image(systemName: "minus")
                                .font(.system(size: 24))
                                .frame(width: 24, height: 24)
                                .foregroundStyle(.gray800)
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(.gray950)
                                )
                        }
                    }
                    
                    Spacer()
                    
                    // MARK: 원정팀의 골 예측
                    VStack(spacing: 16) {
                        // 원정팀 예상 골 개수 추가
                        Button {
                            if (awayTeamGoal < 10) {
                                awayTeamGoal += 1
                            }
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 24))
                                .frame(width: 24, height: 24)
                                .foregroundStyle(.white)
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(.gray950)
                                )
                        }
                        
                        // 원정팀의 예상 골 개수
                        HStack(spacing: 8) {
                            Text("\(awayTeamGoal)")
                                .pretendardTextStyle(.H1Style)
                                .foregroundStyle(.lime)
                                .frame(width: 30)
                            
                            Text("골")
                                .pretendardTextStyle(.Body1Style)
                                .foregroundStyle(.gray200)
                                .frame(width: 30)
                        }
                        
                        // 원정팀 예상 골 개수 삭제
                        Button {
                            if (awayTeamGoal > 0) {
                                awayTeamGoal -= 1
                            }
                        } label: {
                            Image(systemName: "minus")
                                .font(.system(size: 24))
                                .frame(width: 24, height: 24)
                                .foregroundStyle(.gray800)
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(.gray950)
                                )
                        }
                    }
                }
                .padding(.horizontal, 60)
                .padding(.top, 42)
                
                Spacer()
                
                // MARK: - 예측하기 버튼
                NavigationLink {
                    FinishWinningTeamPrediction(winningPrediction: WinningPrediction(id: 0, homeTeamName: soccerMatch.homeTeam.teamName, awayTeamName: soccerMatch.awayTeam.teamName, homeTeamScore: homeTeamGoal, awayTeamScore: awayTeamGoal))
                        .toolbar(.hidden)
                } label: {
                    DesignWideButton(label: "예측하기", labelColor: Color.black, btnBGColor: Color.lime)
                        .padding(.bottom, 34)
                }
            }
        }
        .navigationTitle("우승 팀 예측")
        // 툴 바, 상태 바 색상 변경
        .ignoresSafeArea(edges: .bottom)
        .toolbarBackground(Color.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

#Preview {
    WinningTeamPrediction(soccerMatch: dummySoccerMatches[2])
}
