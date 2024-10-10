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
    /// 경기 캘린더 뷰모델
    @ObservedObject var viewModel: MatchCalendarViewModel
    
    /// 선발라인업 뷰모델
    @StateObject var lineupViewModel: StartingLineupViewModel
    
    // 뷰모델 초기화
    init(viewModel: MatchCalendarViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
        _lineupViewModel = StateObject(wrappedValue: StartingLineupViewModel(matchId: viewModel.selectedSoccerMatch?.id))
    }
    
    // MARK: - BODY
    var body: some View {
        ZStack(alignment: .top) {
            // 배경화면 색상
            Color(.background)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // MARK: 홈팀
                    teamInfo(true)
                    ZStack {
                        soccerFiled(true)
                        if let lineup = lineupViewModel.homeLineups {
                            lineups(isHomeTeam: true, for: lineupViewModel.homeFormations, lineup: lineup)
                        }
                    }
                    
                    // MARK: 원정팀
                    teamInfo(false)
                    ZStack {
                        soccerFiled(false)
                        if let lineup = lineupViewModel.awayLineups {
                            lineups(isHomeTeam: false, for: lineupViewModel.awayFormations, lineup: lineup)
                        }
                    }
                    
                    // MARK: 감독
                    VStack(spacing: 0) {
                        chartTitle("\(viewModel.teamInfoView(for: true).1) 감독", "\(viewModel.teamInfoView(for: false).1) 감독")
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
                        chartTitle("\(viewModel.teamInfoView(for: true).1) 후보선수", "\(viewModel.teamInfoView(for: false).1) 후보선수")
                        
                        // 두 배열 중 배열 크기가 큰 배열로 반복 횟수 설정
                        let maxCount = max(lineupViewModel.homeSubstitutes.count, lineupViewModel.awaySubstitutes.count)
                        
                        ForEach(0..<maxCount, id: \.self) { index in
                            chartDivider() // 구분선
                            
                            // 홈팀 후보선수
                            let homePlayer = lineupViewModel.homeSubstitutes[safe: index]
                            
                            // 원정팀 후보선수
                            let awayPlayer = lineupViewModel.awaySubstitutes[safe: index]
                            
                            playerChartContent(
                                homePlayer?.playerNum ?? -1,
                                homePlayer?.playerName ?? "",
                                awayPlayer?.playerNum ?? -1,
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
        } //: ZSTACK
        .navigationTitle("선발 라인업")
    }
    
    // MARK: - FUNCTION
    /// 팀 엠블럼&이미지
    @ViewBuilder
    private func teamInfo(_ isHomeTeam: Bool) -> some View {
        HStack(spacing: 8) {
            LoadableImage(image: viewModel.teamInfoView(for: isHomeTeam).0)
                .frame(width: 32, height: 32)
            
            Text(viewModel.teamInfoView(for: isHomeTeam).1)
                .pretendardTextStyle(.Title2Style)
                .foregroundStyle(.white0)
            
            Spacer()
            
            Text("\(isHomeTeam ? lineupViewModel.homeFormation : lineupViewModel.awayFormation) 포메이션")
                .pretendardTextStyle(.SubTitleStyle)
                .foregroundStyle(.white0)
        }
        .padding(.top, 20)
        .padding(.bottom, 16)
    }
    
    /// 선발라인업 선수 리스트
    @ViewBuilder
    private func lineups(isHomeTeam: Bool, for formations: [Int], lineup: StartingLineupModel) -> some View {
        VStack(spacing: 0) {
            // 포메이션이 3줄이라면
            if formations.count == 3 {
                VStack(alignment: .center, spacing: 22) {
                    ForEach(Array(playerViews(isHomeTeam: isHomeTeam, for: lineup).enumerated()), id: \.offset) { _, view in
                        view
                    }
                }
            }
            // 포메이션이 4줄이라면
            else {
                VStack(alignment: .center, spacing: 4) {
                    ForEach(Array(playerViews(isHomeTeam: isHomeTeam, for: lineup).enumerated()), id: \.offset) { _, view in
                        view
                    }
                }
            }
        }
    }
    
    /// 선수 리스트 반환 함수
    private func playerViews(isHomeTeam: Bool, for lineup: StartingLineupModel) -> [AnyView] {
        // 뷰들이 추가될 리스트
        var views: [AnyView] = []
        
        // 골기퍼
        views.append(AnyView(PredictionPlayerSelectedCardView(player: lineupViewModel.lineupPlayerToEntity(lineup.goalkeeper))))
        
        // 수비수 리스트
        let defenders = HStack(spacing: 12) {
            ForEach(0..<lineup.defenders.count, id: \.self) { i in
                PredictionPlayerSelectedCardView(player: lineupViewModel.lineupPlayerToEntity(lineup.defenders[i]))
            }
        }
        views.append(AnyView(defenders))
        
        // 미드필더 리스트
        let midfielders = HStack(spacing: 12) {
            ForEach(0..<lineup.midfielders.count, id: \.self) { i in
                PredictionPlayerSelectedCardView(player: lineupViewModel.lineupPlayerToEntity(lineup.midfielders[i]))
            }
        }
        views.append(AnyView(midfielders))
        
        // 추가 미드필더 리스트
        if let extraMidfielders = lineup.midfielders2 {
            let midfielders2 = HStack(spacing: 12) {
                ForEach(0..<extraMidfielders.count, id: \.self) { i in
                    PredictionPlayerSelectedCardView(player: lineupViewModel.lineupPlayerToEntity(extraMidfielders[i]))
                }
            }
            views.append(AnyView(midfielders2))
        }
        
        // 공격수 리스트
        let strikers = HStack(spacing: 12) {
            ForEach(0..<lineup.strikers.count, id: \.self) { i in
                PredictionPlayerSelectedCardView(player: lineupViewModel.lineupPlayerToEntity(lineup.strikers[i]))
            }
        }
        views.append(AnyView(strikers))
        
        return isHomeTeam ? views : views.reversed()
    }
    
    /// 축구장 이미지
    @ViewBuilder
    private func soccerFiled(_ isHomeTeam: Bool) -> some View {
        Image(.soccerField)
            .resizable()
            .frame(height: 330)
            .rotationEffect(isHomeTeam ? Angle(degrees: 0) : Angle(degrees: 180))
            .clipShape(
                SpecificRoundedRectangle(radius: 8, corners: isHomeTeam ? [.topLeft, .topRight] : [.bottomLeft, .bottomRight])
            )
            .overlay {
                SpecificRoundedRectangle(radius: 8, corners: isHomeTeam ? [.topLeft, .topRight] : [.bottomLeft, .bottomRight])
                    .fill(.black)
                    .opacity(0.2)
            }
    }
    
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
    StartingLineup(viewModel: MatchCalendarViewModel())
}
