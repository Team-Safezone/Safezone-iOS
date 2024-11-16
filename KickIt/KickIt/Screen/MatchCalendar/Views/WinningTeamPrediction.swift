//
//  WinningTeamPrediction.swift
//  KickIt
//
//  Created by 이윤지 on 5/26/24.
//

import Charts
import SwiftUI

/// 우승팀 예측 화면
struct WinningTeamPrediction: View {
    /// 예측  처음 시도 or 예측 수정 여부
    var isRetry: Bool
    
    /// 축구 경기 객체
    var soccerMatch: SoccerMatch
    
    /// 우승팀 예측 화면 뷰모델
    @StateObject var viewModel = WinningTeamPredictionViewModel()
    
    var body: some View {
        ZStack {
            Color(.background)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                // MARK: - 질문
                PredictionQuestionView(predictionType: 0, isRetry: false, matchCode: soccerMatch.matchCode, questionTitle: "우승 팀 예측", question: "이번 경기에서 몇 골을 넣을까?", matchDate: soccerMatch.matchDate, matchTime: soccerMatch.matchTime)
                    .padding(.top, 12)
                    .padding(.horizontal, 16)
                
                // MARK: - 팀 정보
                HStack(alignment: .center) {
                    // MARK: 홈 팀
                    VStack(alignment: .center, spacing: 0) {
                        // 홈 팀 엠블럼 이미지
                        LoadableImage(image: soccerMatch.homeTeam.teamEmblemURL)
                            .frame(width: 88, height: 88)
                        
                        HStack(spacing: 0) {
                            Image(uiImage: .homeTeam)
                                .foregroundStyle(.gray500Text)
                                .font(.system(size: 15))
                            
                            // 팀 명
                            Text("\(soccerMatch.homeTeam.teamName)")
                                .pretendardTextStyle(.Body1Style)
                                .foregroundStyle(.white0)
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
                        
                        // 팀 명
                        Text("\(soccerMatch.awayTeam.teamName)")
                            .pretendardTextStyle(.Body1Style)
                            .foregroundStyle(.white0)
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
                            viewModel.addHomeTeamGoal()
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 24))
                                .frame(width: 24, height: 24)
                                .foregroundStyle(.white)
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(.gray800)
                                )
                        }
                        .disabled(viewModel.homeTeamGoal == 10)
                        
                        // 홈팀의 예상 골 개수
                        HStack(spacing: 8) {
                            Text("\(viewModel.homeTeamGoal)")
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
                            viewModel.minusHomeTeamGoal()
                        } label: {
                            Image(systemName: "minus")
                                .font(.system(size: 24))
                                .frame(width: 24, height: 24)
                                .foregroundStyle(viewModel.homeTeamGoal == 0 ? .gray800Btn : .white0)
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(viewModel.homeTeamGoal == 0 ? .gray900Assets : .gray800)
                                )
                        }
                        .disabled(viewModel.homeTeamGoal == 0)
                    }
                    
                    Spacer()
                    
                    // MARK: 원정팀의 골 예측
                    VStack(spacing: 16) {
                        // 원정팀 예상 골 개수 추가
                        Button {
                            viewModel.addAwayTeamGoal()
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 24))
                                .frame(width: 24, height: 24)
                                .foregroundStyle(.white)
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(.gray800)
                                )
                        }
                        .disabled(viewModel.awayTeamGoal == 10)
                        
                        // 원정팀의 예상 골 개수
                        HStack(spacing: 8) {
                            Text("\(viewModel.awayTeamGoal)")
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
                            viewModel.minusAwayTeamGoal()
                        } label: {
                            Image(systemName: "minus")
                                .font(.system(size: 24))
                                .frame(width: 24, height: 24)
                                .foregroundStyle(viewModel.awayTeamGoal == 0 ? .gray800Btn : .white0)
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(viewModel.awayTeamGoal == 0 ? .gray900Assets : .gray800)
                                )
                        }
                        .disabled(viewModel.awayTeamGoal == 0)
                    }
                }
                .padding(.horizontal, 60)
                .padding(.top, 42)
                
                Spacer()
                
                // MARK: - 예측하기 버튼
                NavigationLink(value: NavigationDestination.finishWinningTeamPrediction(
                    data: FinishWinningTeamPredictionNVData(
                        winningPrediction: WinningPrediction(
                            id: soccerMatch.id,
                            homeTeamName: soccerMatch.homeTeam.teamName,
                            awayTeamName: soccerMatch.awayTeam.teamName,
                            homeTeamScore: viewModel.homeTeamGoal,
                            awayTeamScore: viewModel.awayTeamGoal,
                            grade: viewModel.grade, point: viewModel.point
                        ),
                        prediction: PredictionQuestionModel(
                            matchId: soccerMatch.id,
                            matchCode: soccerMatch.matchCode,
                            matchDate: soccerMatch.matchDate,
                            matchTime: soccerMatch.matchTime,
                            homeTeam: soccerMatch.homeTeam,
                            awayTeam: soccerMatch.awayTeam
                    )))) {
                        DesignWideButton(label: "예측하기", labelColor: .blackAssets, btnBGColor: .lime)
                            .padding(.bottom, 34)
                            .padding(.horizontal, 16)
                }
                .simultaneousGesture(TapGesture().onEnded {
                    // 우승팀 예측하기 API 호출
                    viewModel.postWinningTeamPrediction(query: MatchIdRequest(matchId: soccerMatch.id), request: WinningTeamPredictionRequest(homeTeamScore: viewModel.homeTeamGoal, awayTeamScore: viewModel.awayTeamGoal))
                })
            }
        }
        .navigationTitle("우승 팀 예측")
    }
}

#Preview {
    WinningTeamPrediction(isRetry: false, soccerMatch: dummySoccerMatches[0])
}
