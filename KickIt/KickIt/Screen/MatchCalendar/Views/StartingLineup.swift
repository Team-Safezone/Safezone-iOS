//
//  StartingLineup.swift
//  KickIt
//
//  Created by 이윤지 on 10/7/24.
//

import SwiftUI

/// 선발라인업 화면
struct StartingLineup: View {
    // MARK: - PROPERTY
    /// 경기 정보
    var soccerMatch: SoccerMatch
    
    /// 선발라인업 뷰모델
    @StateObject var lineupViewModel: StartingLineupViewModel
    
    // 뷰모델 초기화
    init(soccerMatch: SoccerMatch) {
        self.soccerMatch = soccerMatch
        _lineupViewModel = StateObject(wrappedValue: StartingLineupViewModel(matchId: soccerMatch.id))
    }
    
    // MARK: - BODY
    var body: some View {
        ZStack(alignment: .top) {
            // 배경화면 색상
            Color(.background)
                .ignoresSafeArea()
            
            if lineupViewModel.isLoading {
                VStack(spacing: 30) {
                    Image(uiImage: .delayStartingLineup)
                    
                    VStack {
                        Text("곧 선발 라인업이 공개될 예정입니다")
                            .pretendardTextStyle(.Body1Style)
                            .foregroundStyle(.white0)
                        
                        Text("조금만 더 기다려 주세요")
                            .pretendardTextStyle(.Body2Style)
                            .foregroundStyle(.gray500Text)
                    }
                }
                .frame(maxHeight: .infinity, alignment: .center)
                .padding(.bottom, 100)
            }
            else {
                ScrollView {
                    VStack(spacing: 0) {
                        // MARK: 홈팀
                        teamInfo(
                            true,
                            SoccerTeam(teamEmblemURL: soccerMatch.homeTeam.teamEmblemURL, teamName: soccerMatch.homeTeam.teamName),
                            SoccerTeam(teamEmblemURL: soccerMatch.awayTeam.teamEmblemURL, teamName: soccerMatch.awayTeam.teamName),
                            lineupViewModel.homeFormation,
                            lineupViewModel.awayFormation
                        )
                        ZStack {
                            soccerFiled(true)
                            if let lineup = lineupViewModel.homeLineups {
                                lineups(isHomeTeam: true, for: lineupViewModel.homeFormation, lineup: lineup)
                            }
                        }
                        
                        // MARK: 원정팀
                        teamInfo(
                            false,
                            SoccerTeam(teamEmblemURL: soccerMatch.homeTeam.teamEmblemURL, teamName: soccerMatch.homeTeam.teamName),
                            SoccerTeam(teamEmblemURL: soccerMatch.awayTeam.teamEmblemURL, teamName: soccerMatch.awayTeam.teamName),
                            lineupViewModel.homeFormation,
                            lineupViewModel.awayFormation
                        )
                        ZStack {
                            soccerFiled(false)
                            if let lineup = lineupViewModel.awayLineups {
                                lineups(isHomeTeam: false, for: lineupViewModel.awayFormation, lineup: lineup)
                            }
                        }
                        
                        // MARK: 감독
                        VStack(spacing: 0) {
                            chartTitle("\(soccerMatch.homeTeam.teamName) 감독", "\(soccerMatch.awayTeam.teamName) 감독")
                            chartDivider()
                            chartContent(lineupViewModel.homeDirector, lineupViewModel.awayDirector)
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.gray900Assets, lineWidth: 1)
                        )
                        .padding(.top, 24)
                        .padding(.bottom, 20)
                        
                        // MARK: 후보선수
                        VStack(spacing: 0) {
                            chartTitle("\(soccerMatch.homeTeam.teamName) 후보선수", "\(soccerMatch.awayTeam.teamName) 후보선수")
                            
                            // 두 배열 중 배열 크기가 큰 배열로 반복 횟수 설정
                            let maxCount = max(lineupViewModel.homeSubstitutes?.count ?? 0, lineupViewModel.awaySubstitutes?.count ?? 0)
                            
                            ForEach(0..<maxCount, id: \.self) { index in
                                chartDivider() // 구분선
                                
                                // 홈팀 후보선수
                                let homePlayer = lineupViewModel.homeSubstitutes?[safe: index]
                                
                                // 원정팀 후보선수
                                let awayPlayer = lineupViewModel.awaySubstitutes?[safe: index]
                                
                                playerChartContent(
                                    homePlayer?.backNum ?? -1,
                                    homePlayer?.playerName ?? "",
                                    awayPlayer?.backNum ?? -1,
                                    awayPlayer?.playerName ?? ""
                                )
                            }
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.gray900Assets, lineWidth: 1)
                        )
                        .padding(.bottom, 26)
                    } //: VSTACK
                    .padding(.horizontal, 16)
                    .padding(.vertical, 20)
                } //: SCROLLVIEW
                .scrollIndicators(.never)
            }
        } //: ZSTACK
        .navigationTitle("선발 라인업")
    }
    
    // MARK: - FUNCTION
    /// 표 제목 뷰
    @ViewBuilder
    private func chartTitle(_ title1: String, _ title2: String) -> some View {
        HStack(spacing: 40) {
            Text(title1)
                .pretendardTextStyle(.Title2Style)
                .foregroundStyle(.white0)
                .frame(maxWidth: .infinity)
            
            Text(title2)
                .pretendardTextStyle(.Title2Style)
                .foregroundStyle(.white0)
                .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 20)
        .background(
            SpecificRoundedRectangle(radius: 8, corners: [.topLeft, .topRight])
                .fill(.gray950)
        )
    }
    
    /// 감독 표 내용 뷰
    @ViewBuilder
    private func chartContent(_ content1: String, _ content2: String) -> some View {
        HStack(spacing: 40) {
            Text(content1)
                .pretendardTextStyle(.Body2Style)
                .foregroundStyle(.white0)
                .frame(maxWidth: .infinity)
            
            Text(content2)
                .pretendardTextStyle(.Body2Style)
                .foregroundStyle(.white0)
                .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
    }
    
    /// 선수 표 내용 뷰
    @ViewBuilder
    private func playerChartContent(_ num1: Int, _ name1: String, _ num2: Int, _ name2: String) -> some View {
        HStack(spacing: 0) {
            playerChartDetail(num1, name1)
            playerChartDetail(num2, name2)
        }
        .padding(.vertical, 10)
    }
    
    /// 개별 선수 표 내용 뷰
    @ViewBuilder
    private func playerChartDetail(_ num: Int, _ name: String) -> some View {
        HStack(spacing: 0) {
            if num != -1 {
                Text("\(num).")
                    .pretendardTextStyle(.Body2Style)
                    .foregroundStyle(.white0)
                    .frame(width: 30, alignment: .leading)
                    .lineLimit(1)
                    .padding(.leading, 30)
            }
            
            Text(name)
                .pretendardTextStyle(.Body2Style)
                .foregroundStyle(.white0)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    /// 표 구분선
    @ViewBuilder
    private func chartDivider() -> some View {
        Rectangle()
            .frame(height: 1)
            .foregroundStyle(.gray900Assets)
    }
}

// MARK: - PREVIEW
#Preview("선발 라인업") {
    StartingLineup(soccerMatch: dummySoccerMatches[0])
}
