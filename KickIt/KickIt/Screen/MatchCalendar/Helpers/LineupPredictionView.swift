//
//  LineupPredictionView.swift
//  KickIt
//
//  Created by 이윤지 on 10/5/24.
//

import SwiftUI

/// 경기 정보 화면에서 사용되는 선발라인업 예측하기 레이아웃
struct LineupPredictionView: View {
    // MARK: - PROPERTY
    /// 경기 객체
    var soccerMatch: SoccerMatch
    
    @ObservedObject var viewModel: MatchCalendarViewModel
    
    /// 경기 예측 조회 뷰모델
    @ObservedObject var pViewModel: PredictionButtonViewModel
    
    /// 타이머 뷰모델
    @ObservedObject var timerViewModel: TimerViewModel
    
    /// 현재 날짜 및 시간
    @State private var nowDate = Date()
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.grayCard)
                .stroke(.limeTransparent, lineWidth: 1)
            
            VStack(alignment: .leading, spacing: 0) {
                // 레이아웃을 좌우하는 상수 값
                let isParticipated = pViewModel.lineupPrediction.isParticipated
                
                HStack(spacing: 0) {
                    // 질문
                    VStack(alignment: .leading) {
                        Text("이번 경기 선발 라인업은?")
                            .pretendardTextStyle(.Title2Style)
                            .foregroundStyle(.white0)
                        HStack(spacing: 4) {
                            switch soccerMatch.matchCode {
                            // 예정
                            case 0, 4:
                                if timerViewModel.isLineupPredictionFinished {
                                    endPredictionText()
                                }
                                else {
                                    Text("진행중")
                                        .pretendardTextStyle(.Body3Style)
                                        .foregroundStyle(.limeText)
                                    
                                    Text(timerViewModel.lineupEndTime)
                                        .pretendardTextStyle(.Body3Style)
                                        .foregroundStyle(.white0)
                                }
                                    
                            // 경기중, 휴식, 종료
                            case 1, 2, 3:
                                endPredictionText()
                            
                            default:
                                EmptyView()
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // 참여여부
                    ZStack {
                        if pViewModel.lineupPrediction.isParticipated {
                            Image(uiImage: .coin)
                                .resizable()
                                .frame(width: 32, height: 32)
                            
                            if let isSuccessful = pViewModel.lineupPrediction.isPredictionSuccessful {
                                if isSuccessful {
                                    Image(uiImage: .coin)
                                        .resizable()
                                        .frame(width: 32, height: 32)
                                        .offset(x: -15, y: 0)
                                }
                            }
                        }
                        else {
                            Image(uiImage: .dashCircle)
                                .resizable()
                                .frame(width: 32, height: 32)
                                .foregroundStyle(.gray800Btn)
                            Text("참여")
                                .pretendardTextStyle(.Caption2Style)
                                .foregroundStyle(.gray500Text)
                        }
                    } //: ZSTACK
                } //: HSTACK
                
                // 실시간 예측
                HStack(spacing: 4) {
                    Rectangle()
                        .foregroundStyle(.gray800)
                        .frame(height: 1)
                    Text("실시간 예측")
                        .pretendardTextStyle(.Body3Style)
                        .foregroundStyle(.gray300)
                    Rectangle()
                        .foregroundStyle(.gray800)
                        .frame(height: 1)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 8)
                
                // 홈팀
                teamFormationInfo(teamInfoView(for: true).0, teamInfoView(for: true).1, true)
                
                // 원정팀
                teamFormationInfo(teamInfoView(for: false).0, teamInfoView(for: false).1, false)
                    .padding(.top, 12)
                
                // 버튼
                switch soccerMatch.matchCode {
                    // 예정
                case 0, 4:
                    if timerViewModel.isLineupPredictionFinished {
                        resultText(isEnd: true)
                    }
                    else {
                        if isParticipated {
                            resultText(isEnd: true)
                        }
                        else {
                            resultText(isEnd: false)
                        }
                    }
                    
                    // 경기중, 휴식, 종료
                case 1, 2, 3:
                    Text("결과보기")
                        .pretendardTextStyle(.SubTitleStyle)
                        .foregroundStyle(.whiteAssets)
                        .padding(.vertical, 11)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .foregroundStyle(.violet)
                        )
                        .padding(.top, 16)
                    
                default:
                    EmptyView()
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 12)
        }
    }
    
    // MARK: - FUNCTION
    /// 예측 종료 텍스트
    @ViewBuilder
    private func endPredictionText() -> some View {
        Text("예측 종료")
            .pretendardTextStyle(.Body3Style)
            .foregroundStyle(.gray300)
        
        Text("\(pViewModel.lineupPrediction.participant ?? 0)명 참여")
            .pretendardTextStyle(.Body3Style)
            .foregroundStyle(.white0)
    }
    
    /// 결과보기 or 참여하기 버튼 텍스트
    @ViewBuilder
    private func resultText(isEnd: Bool) -> some View {
        Text(isEnd ? "결과보기" : "참여하기")
            .pretendardTextStyle(.SubTitleStyle)
            .foregroundStyle(isEnd ? .whiteAssets : .blackAssets)
            .padding(.vertical, 11)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .foregroundStyle(isEnd ? .violet : .lime)
            )
            .padding(.top, 16)
    }
    
    /// 팀 포메이션 정보
    @ViewBuilder
    private func teamFormationInfo(_ url: String, _ name: String, _ isHomeTeam: Bool) -> some View {
        HStack(spacing: 0) {
            // 팀 엠블럼
            LoadableImage(image: url)
                .frame(width: 44, height: 44)
                .padding(.trailing, 6)
            
            // 팀 이름
            Text(name)
                .pretendardTextStyle(.Caption1Style)
                .foregroundStyle(.white0)
            
            Spacer()
            
            // 포메이션
            Text(pViewModel.formationInfo(for: isHomeTeam).0)
                .pretendardTextStyle(.Title2Style)
                .foregroundStyle(.white0)
                .padding(.trailing, 4)
            
            Text("포메이션")
                .pretendardTextStyle(.Body2Style)
                .foregroundStyle(.white0)
                .padding(.trailing, 10)
            
            // 0퍼센트라면(예측을 안 했다면)
            let percentage = pViewModel.formationInfo(for: isHomeTeam).1
            if percentage == 0 {
                Text("\(percentage)")
                    .pretendardTextStyle(.Title1Style)
                    .foregroundStyle(.gray300)
                Text("%")
                    .pretendardTextStyle(.Title1Style)
                    .foregroundStyle(.gray300Assets)
            }
            // 예측 결과가 있다면
            else {
                Text("\(percentage)")
                    .pretendardTextStyle(.Title1Style)
                    .foregroundStyle(.limeText)
                Text("%")
                    .pretendardTextStyle(.Title1Style)
                    .foregroundStyle(.lime)
            }
        }
    }
    
    /// 팀 정보에 따른 값(이름, 이미지) 반환
    private func teamInfoView(for isHomeTeam: Bool) -> (String, String) {
        let team = isHomeTeam ? soccerMatch.homeTeam : soccerMatch.awayTeam
        return (team.teamEmblemURL, team.teamName)
    }
}

// MARK: - PREVIEW
#Preview("선발라인업 예측 조회") {
    LineupPredictionView(soccerMatch: dummySoccerMatches[0], viewModel: MatchCalendarViewModel(), pViewModel: PredictionButtonViewModel(), timerViewModel: TimerViewModel())
}
