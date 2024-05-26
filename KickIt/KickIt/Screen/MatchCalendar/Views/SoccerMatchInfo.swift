//
//  SoccerMatchInfo.swift
//  KickIt
//
//  Created by 이윤지 on 5/18/24.
//

import SwiftUI

/// 1개의 축구 경기 정보 화면
struct SoccerMatchInfo: View {
    /// 축구 경기 객체
    var soccerMatch: SoccerMatch
    
    /// 예측하기 패널의 높이 값
    @State var offsetY: CGFloat = 0
    
    /// 예측하기 버튼 클릭 상태 여부
    @State private var isPredicted = false
    
    var body: some View {
        ZStack(alignment: .top) {
            // 배경화면 색 지정
            Color(.gray100)
            
            ScrollView {
                VStack(alignment: .center, spacing: 0) {
                    // MARK: - 경기 타임라인 버튼
                    HStack(alignment: .bottom, spacing: 0) {
                        VStack(alignment: .trailing, spacing: 0) {
                            // MARK: - 실시간 레이블
                            if (soccerMatch.matchCode == 1) {
                                Text("실시간")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)
                                    .padding([.top, .bottom], 4)
                                    .padding([.leading, .trailing], 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(.gray600)
                                    )
                                    .padding(.bottom, 7)
                            }
                            
                            Text("경기 타임라인")
                                .font(.callout)
                                .fontWeight(.semibold)
                                .foregroundStyle(timeLineTextColor())
                        }
                        
                        Image(systemName: "arrow.up.right")
                            .font(.headline)
                            .foregroundStyle(timeLineTextColor())
                            .padding(.leading, 10)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.top, 20)
                    .padding(.trailing, 16)
                    
                    // MARK: - 경기 정보
                    Text(soccerMatchLabel())
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(soccerMatchLabelColor().0)
                        .padding([.leading, .trailing], 20)
                        .padding([.top, .bottom], 6)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(soccerMatchLabelColor().1)
                        )
                        .padding(.top, 45)
                    
                    // MARK: - 경기 날짜
                    Text("\(dateToString2(date: soccerMatch.matchDate))")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(.black)
                        .padding(.top, 18)
                    
                    // MARK: - 경기 시간
                    Text("\(timeToString(time: soccerMatch.matchTime))")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.black)
                        .padding(.top, 11)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        // MARK: - 팀 정보
                        HStack(alignment: .top, spacing: 0) {
                            // MARK: 홈 팀
                            VStack(alignment: .center, spacing: 0) {
                                // 홈 팀 엠블럼 이미지
                                LoadableImage(image: soccerMatch.homeTeam.teamImgURL)
                                    .frame(width: 88, height: 88)
                                    .background(.white)
                                    .clipShape(Circle())
                                
                                // 팀 명
                                Text("\(soccerMatch.homeTeam.teamName)")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.gray600)
                                    .frame(width: 88, alignment: .center)
                                    .padding(.top, 8)
                                
                                Text("홈")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundStyle(.gray600)
                                    .padding(.top, 19)
                                
                                // 홈 팀 스코어
                                Text("\(soccerMatch.homeTeamScore?.description ?? "-")")
                                    .font(.system(size: 30, weight: .semibold))
                                    .foregroundStyle(.black)
                                    .padding(.top, 30)
                            }
                            
                            Spacer()
                            
                            Text("VS")
                                .font(.system(size: 28, weight: .semibold))
                                .foregroundStyle(.gray600)
                                .padding(.top, 37)
                            
                            Spacer()
                            
                            // MARK: 원정 팀
                            VStack(alignment: .center, spacing: 0) {
                                // 원정 팀 엠블럼 이미지
                                LoadableImage(image: soccerMatch.awayTeam.teamImgURL)
                                    .frame(width: 88, height: 88)
                                    .background(.white)
                                    .clipShape(Circle())
                                
                                // 팀 명
                                Text("\(soccerMatch.awayTeam.teamName)")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.gray600)
                                    .frame(width: 88, alignment: .center)
                                    .padding(.top, 8)
                                
                                Text("원정")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundStyle(.clear)
                                    .padding(.top, 19)
                                
                                // 원정 팀 스코어
                                Text("\(soccerMatch.awayTeamScore?.description ?? "-")")
                                    .font(.system(size: 30, weight: .semibold))
                                    .foregroundStyle(.black)
                                    .padding(.top, 30)
                            }
                        }
                        
                        // MARK: - 라인업 보러가기
                        HStack(alignment: .center, spacing: 0) {
                            Text("라인업 보러가기")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundStyle(.gray600)
                                .padding(.trailing, 4)
                            
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.gray600)
                        }
                        .padding(.top, 42)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding([.leading, .trailing], 30)
                    
                    // 작은 디바이스를 위한 스크롤 및 여백용 하단 박스
                    Rectangle()
                        .frame(height: 300)
                        .foregroundStyle(.clear)
                }
            }
            .scrollIndicators(.never)
            
            // MARK: - 심박수 통계 버튼
            HeartRateButton(soccerMatch: soccerMatch)
                .frame(maxHeight: offsetY - 16, alignment: .bottom)
            
            // MARK: - 예측하기 패널
            PredictionPanel(offsetY: $offsetY) {
                isPredicted = true
            }
            .frame(alignment: .bottom)
        }
        .navigationDestination(isPresented: $isPredicted) {
            WinningTeamPrediction(soccerMatch: soccerMatch)
        }
        .ignoresSafeArea(edges: .bottom)
        // 툴 바, 상태 바 색상 변경
        .toolbarBackground(Color.gray100, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
    
    /// 경기 상태에 따른 타임라인 텍스트 색상 값을 반환하는 함수
    private func timeLineTextColor() -> Color {
        switch (soccerMatch.matchCode) {
        case 0: Color.gray400
        default: Color.gray600
        }
    }
    
    /// 경기 상태에 따른 경기 텍스트&배경 색상 값을 반환하는 함수
    private func soccerMatchLabelColor() -> (Color, Color) {
        switch (soccerMatch.matchCode) {
        case 0: return (Color.gray600, Color.gray50)
        case 1: return (Color.white, Color.gray400)
        case 2: return (Color.white, Color.gray600)
        default: return (Color.gray600, Color.white)
        }
    }
    
    /// 경기 상태 텍스트 값을 반환하는 함수
    private func soccerMatchLabel() -> String {
        switch (soccerMatch.matchCode) {
        case 0: "경기 예정"
        case 1: "경기 중"
        case 2: "경기 종료"
        default: "경기 예정"
        }
    }
}

#Preview {
    SoccerMatchInfo(soccerMatch: soccerMatches[0])
}
