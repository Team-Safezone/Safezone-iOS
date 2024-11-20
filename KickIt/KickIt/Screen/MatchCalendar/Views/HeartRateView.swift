//
//  HeartRateView.swift
//  KickIt
//
//  Created by DaeunLee on 7/28/24.
//

import SwiftUI

/// 심박수 통계 화면
struct HeartRateView: View {
    
    /// back 버튼 색상
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var viewModel: HeartRateViewModel
    
    init(match: SoccerMatch) {
        _viewModel = StateObject(wrappedValue: HeartRateViewModel(match: match))
    }
    
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
                    FanListView(homeTeamName: viewModel.selectedMatch.homeTeam.teamName, awayTeamName: viewModel.selectedMatch.awayTeam.teamName)
                    
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
                        homeTeamName: viewModel.selectedMatch.homeTeam.teamName,
                        awayTeamName: viewModel.selectedMatch.awayTeam.teamName
                    )
                    
                    // MARK: 심박수 통계 화면의 전체 시청자 분석 막대 그래프
                    ViewerStatsView(
                        homeTeam: viewModel.selectedMatch.homeTeam,
                        awayTeam: viewModel.selectedMatch.awayTeam,
                        homeTeamPercentage: viewModel.statistics?.homeTeamViewerPercentage ?? 0
                    )
                }//:VSTACK
            }//:SCROLLVIEW
            .onAppear {
                viewModel.getHeartRateStatistics(matchId: viewModel.selectedMatch.id)
            }
            .navigationTitle("심박수 통계")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
                .toolbar {  // back 색상
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.white0) // 색상
                            }
                        }
                    }
                }
        }//:ZSTACK
    }
}

#Preview {
    HeartRateView(match: dummySoccerMatches[0])
}
