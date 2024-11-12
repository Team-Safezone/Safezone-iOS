//
//  HeartRateView.swift
//  KickIt
//
//  Created by DaeunLee on 7/28/24.
//

import SwiftUI

/// 심박수 통계 화면
struct HeartRateView: View {
    /// 심박수 통계 뷰모델
    @ObservedObject private var viewModel = HeartRateViewModel()
    /// 사용자가 선택한 축구 경기 객체
    var selectedMatch: SoccerMatch
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    HStack {
                        Text("심박수 그래프")
                            .pretendardTextStyle(.Title1Style)
                        Spacer()
                        HStack(spacing: 6) {
                            Text("\(viewModel.statistics?.lowHeartRate ?? 0) ~ \(viewModel.statistics?.highHeartRate ?? 0)")
                                .pretendardTextStyle(.Title1Style)
                            Text("BPM")
                                .font(.pretendard(.medium, size: 13))
                                .foregroundColor(.gray800Assets)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 30)
                    
                    // MARK: 심박수 그래프
                    LineChartView(viewModel: viewModel)
                        .frame(height: 300)  // 적절한 높이를 지정
                        .padding(.leading, 16)
                        .padding(.bottom, 20)
                    
                    // MARK: 심박수 통계 그래프 아래의 정보 뷰(나, 홈팀, 원정팀)
                    FanListView(homeTeamName: selectedMatch.homeTeam.teamName, awayTeamName: selectedMatch.awayTeam.teamName)
                    
                    // 홈팀 심박수 배열
                    let homeTeamStats: [Int?] = [
                        viewModel.statistics?.homeTeamHeartRate.min,
                        viewModel.statistics?.homeTeamHeartRate.avg,
                        viewModel.statistics?.homeTeamHeartRate.max
                    ]
                    
                    // 원정팀 심박수 배열
                    let awayTeamStats: [Int?] = [
                        viewModel.statistics?.awayTeamHeartRate.min,
                        viewModel.statistics?.awayTeamHeartRate.avg,
                        viewModel.statistics?.awayTeamHeartRate.max
                    ]
                    
                    // MARK: 심박수 통계 화면의 심박수 비교 표(홈팀, 원정팀)
                    ViewerHRStatsView(
                        homeTeamStats: homeTeamStats,
                        awayTeamStats: awayTeamStats,
                        homeTeamName: selectedMatch.homeTeam.teamName,
                        awayTeamName: selectedMatch.awayTeam.teamName
                    )
                    
                    // MARK: 심박수 통계 화면의 전체 시청자 분석 막대 그래프
                    ViewerStatsView(
                        homeTeam: selectedMatch.homeTeam,
                        awayTeam: selectedMatch.awayTeam,
                        homeTeamPercentage: viewModel.statistics?.homeTeamViewerPercentage ?? 0
                    )
                }//:VSTACK
            }//:SCROLLVIEW
            .onAppear {
                viewModel.getHeartRateStatistics(matchId: selectedMatch.id)
            }
            .navigationTitle("심박수 통계")
            .navigationBarTitleDisplayMode(.inline)
        }//:ZSTACK
    }
}

#Preview {
    HeartRateView(selectedMatch: dummySoccerMatches[1])
}
