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
                        .padding(.top, 20)
                        .padding(.bottom, 16)
                    soccerFiled(true)
                    
                    // MARK: 원정팀
                    teamInfo(false)
                        .padding(.top, 20)
                        .padding(.bottom, 16)
                    soccerFiled(false)
                        .padding(.bottom, 24)
                    
                    // MARK: 감독
                    VStack(spacing: 0) {
                        chartTitle("토트넘 감독", "첼시 감독")
                        chartDivider()
                        chartContent("안지 포스테코글루", "엔초 마레스카")
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.gray900Assets, lineWidth: 1)
                    )
                    .padding(.bottom, 20)
                    
                    // MARK: 후보선수
                    VStack(spacing: 0) {
                        chartTitle("첼시 후보선수", "토트넘 후보선수")
                        chartDivider()
                        playerChartContent(5, "주앙 펠릭스", 2, "오도베르")
                        chartDivider()
                        playerChartContent(4, "은쿤쿠", 40, "사르")
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
            
            Text("4-2-3-1 포메이션")
                .pretendardTextStyle(.SubTitleStyle)
                .foregroundStyle(.white0)
        }
    }
    
    /// 선발라인업 뷰
    @ViewBuilder
    private func soccerFiled(_ isHomeTeam: Bool) -> some View {
        ZStack {
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
            Text("\(num).")
                .pretendardTextStyle(.Body2Style)
                .foregroundStyle(.white0)
                .frame(width: 30, alignment: .leading)
                .lineLimit(1)
                .padding(.leading, 30)
            
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
