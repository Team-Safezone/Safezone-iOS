//
//  Ranking.swift
//  KickIt
//
//  Created by 이윤지 on 10/23/24.
//

import SwiftUI

/// 랭킹 화면
struct Ranking: View {
    // MARK: - PROPERTY
    /// 뷰모델
    @StateObject var viewModel = RankingViewModel()
    
    @ObservedObject var calendarViewModel: MatchCalendarViewModel
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            // 배경색
            Color(.background)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // MARK: 시즌정보
                    Text("\(calendarViewModel.soccerSeason) 시즌")
                        .pretendardTextStyle(.Title2Style)
                        .foregroundStyle(.white0)
                        .padding(.top, 10)
                        .padding(.bottom, 14)
                    
                    // MARK: 랭킹
                    VStack(spacing: 0) {
                        chartTitle()
                        
                        ForEach(viewModel.rankings) { rank in
                            chartDivider() // 구분선
                            
                            // 표 내용
                            chartContent(ranking: rank)
                        }
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.gray900Assets, lineWidth: 1)
                    )
                    
                    // MARK: 챔스, 유로파, 강등권
                    VStack(alignment: .leading, spacing: 4) {
                        bottomInfo(color: .lime, info: "챔피언스리그 조별 리그")
                        bottomInfo(color: .green0, info: "유로파리그 조별 리그")
                        bottomInfo(color: .red0, info: "강등")
                    }
                    .padding(.leading, 8)
                    .padding(.top, 16)
                    .padding(.bottom, 20)
                }
                .padding(.horizontal, 16)
            } //: SCROLLVIEW
            .scrollIndicators(.never)
        } //: ZSTACK
        .navigationTitle("랭킹")
    }
    
    // MARK: - FUNCTION
    /// 표 제목 뷰
    @ViewBuilder
    private func chartTitle() -> some View {
        HStack(spacing: 0) {
            Text("순위")
                .padding(.trailing, 11)
            Text("팀")
            
            Spacer()
            
            Text("경기")
                .padding(.trailing, 14)
            HStack(spacing: 22) {
                Text("승")
                Text("무")
                Text("패")
            }
            .foregroundStyle(.gray500Text)
            .padding(.trailing, 16)
            Text("승점")
        }
        .pretendardTextStyle(.SubTitleStyle)
        .foregroundStyle(.white0)
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
        .background(
            SpecificRoundedRectangle(radius: 8, corners: [.topLeft, .topRight])
                .fill(.gray950)
        )
    }
    
    /// 표 콘텐츠 뷰
    @ViewBuilder
    private func chartContent(ranking: RankingModel) -> some View {
        HStack(spacing: 0) {
            // 순위
            Text("\(ranking.team.ranking ?? -1)")
                .pretendardTextStyle(.SubTitleStyle)
                .foregroundStyle(rankingColor(leagueCategory: ranking.leagueCategory ?? 4))
                .frame(width: 20, alignment: .center)
                .padding(.trailing, 10)
            
            // 팀엠블럼 & 팀이름
            HStack(alignment: .center, spacing: 4) {
                LoadableImage(image: ranking.team.teamEmblemURL)
                    .frame(width: 24, height: 24)
                Text(ranking.team.teamName)
                    .pretendardTextStyle(.Body2Style)
                    .foregroundStyle(.white0)
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                chartNum(num: ranking.totalMatches, color: .white0) // 총 경기
                chartNum(num: ranking.wins, color: .gray500Text) // 승
                chartNum(num: ranking.draws, color: .gray500Text) // 무
                chartNum(num: ranking.losses, color: .gray500Text) // 패
                chartPoints(num: ranking.points) // 승점
            }
            .padding(.trailing, 4)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 8)
    }
    
    /// 경기 숫자
    @ViewBuilder
    private func chartNum(num: Int, color: Color) -> some View {
        Text("\(num)")
            .pretendardTextStyle(.Body2Style)
            .foregroundStyle(color)
            .frame(width: 18)
    }
    
    /// 승점
    @ViewBuilder
    private func chartPoints(num: Int) -> some View {
        Text("\(num)")
            .pretendardTextStyle(.SubTitleStyle)
            .foregroundStyle(.lime)
            .frame(width: 18)
    }
    
    /// 표 구분선
    @ViewBuilder
    private func chartDivider() -> some View {
        Rectangle()
            .frame(height: 1)
            .foregroundStyle(.gray900Assets)
    }
    
    /// 순위 색상 지정
    private func rankingColor(leagueCategory: Int) -> Color {
        switch leagueCategory {
        case 0:
            return .lime
        case 1:
            return .green0
        case 2:
            return .red0
        default:
            return .white0
        }
    }
    
    /// 하단 정보
    @ViewBuilder
    private func bottomInfo(color: Color, info: String) -> some View {
        HStack(spacing: 6) {
            RoundedRectangle(cornerRadius: 2)
                .foregroundStyle(color)
                .frame(width: 15, height: 15)
            Text(info)
                .pretendardTextStyle(.Body3Style)
                .foregroundStyle(.white0)
            Spacer()
        }
    }
}

// MARK: - PREVIEW
#Preview("랭킹") {
    Ranking(calendarViewModel: MatchCalendarViewModel())
}
