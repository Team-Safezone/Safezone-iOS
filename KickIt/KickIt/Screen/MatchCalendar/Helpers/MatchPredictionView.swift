//
//  MatchPredictionView.swift
//  KickIt
//
//  Created by 이윤지 on 10/5/24.
//

import SwiftUI

/// 경기 정보 화면에서 사용되는 우승팀 예측하기 레이아웃
struct MatchPredictionView: View {
    // MARK: - PROPERTY
    /// 경기 캘린더 뷰모델
    @ObservedObject var viewModel: MatchCalendarViewModel
    
    /// 경기 예측 조회 뷰모델
    @ObservedObject var pViewModel: PredictionButtonViewModel
    
    /// 현재 날짜 및 시간
    @State private var nowDate = Date()
    
    /// 예측 타이머 종료 여부
    @State private var isPredictionFinished: Bool = false
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.grayCard)
                .stroke(.limeTransparent, lineWidth: 1)
            
            VStack(alignment: .leading, spacing: 0) {
                // 레이아웃을 좌우하는 상수 값
                let isParticipated = pViewModel.matchPrediction.isParticipated
                let isEnd = isParticipated || isPredictionFinished ? true : false
                
                HStack(spacing: 0) {
                    // 질문
                    VStack(alignment: .leading) {
                        Text("이번 경기 결과는?")
                            .pretendardTextStyle(.Title2Style)
                            .foregroundStyle(.white0)
                        HStack(spacing: 4) {
                            switch viewModel.selectedSoccerMatch?.matchCode {
                            // 예정
                            case 0, 4:
                                if !isEnd {
                                    Text("진행중")
                                        .pretendardTextStyle(.Body3Style)
                                        .foregroundStyle(.limeText)
                                    
                                    Text(viewModel.matchEndTimePredictionInterval(nowDate))
                                        .pretendardTextStyle(.Body3Style)
                                        .foregroundStyle(.white0)
                                }
                                else {
                                    endPredictionText()
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
                        if pViewModel.matchPrediction.isParticipated {
                            Image(uiImage: .coin)
                                .resizable()
                                .frame(width: 32, height: 32)
                            
                            if let isSuccessful = pViewModel.matchPrediction.isPredictionSuccessful {
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
                
                HStack {
                    // 홈팀
                    teamInfo(viewModel.teamInfoView(for: true).0, viewModel.teamInfoView(for: true).1)
                    
                    Spacer()
                    
                    // 각팀 우승 확률
                    HStack(spacing: 10) {
                        let homePercentage = pViewModel.matchPrediction.homePercentage // 홈팀 우승 확률
                        let awayPercentage = homePercentage != 0 ? (100 - homePercentage) : 0 // 원정팀 우승 확률
                        
                        // 아무도 예측하지 않았을 경우
                        if homePercentage == 0 && awayPercentage == 0 {
                            percentageTextStyle(homePercentage, isWinner: false)
                            percentageText()
                            percentageTextStyle(awayPercentage, isWinner: false)
                        }
                        // 무승부
                        else if homePercentage == awayPercentage {
                            percentageTextStyle(homePercentage, isWinner: true)
                            percentageText()
                            percentageTextStyle(awayPercentage, isWinner: true)
                        }
                        // 홈팀 우승
                        else if homePercentage > awayPercentage {
                            percentageTextStyle(homePercentage, isWinner: true)
                            percentageText()
                            percentageTextStyle(awayPercentage, isWinner: false)
                        }
                        // 원정팀 우승
                        else {
                            percentageTextStyle(homePercentage, isWinner: false)
                            percentageText()
                            percentageTextStyle(awayPercentage, isWinner: true)
                        }
                    }
                    
                    Spacer()
                    
                    // 원정팀
                    teamInfo(viewModel.teamInfoView(for: false).0, viewModel.teamInfoView(for: false).1)
                }
                .padding(.horizontal, 8)
                
                // 참여하기 or 결과보기 버튼
                switch viewModel.selectedSoccerMatch?.matchCode {
                    // 예정
                case 0, 4:
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
        .onAppear {
            startTimer()
        }
    }
    
    // MARK: - FUNCTION
    /// 예측 종료 마감까지의 시간 계산
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.nowDate = Date()
            
            // 예측 종료 시간이 됐다면
            if nowDate >= viewModel.matchEndTimePredictionShowDate(nowDate) {
                timer.invalidate()
                isPredictionFinished = true
            }
        }
    }
    
    /// 예측 종료 텍스트
    @ViewBuilder
    private func endPredictionText() -> some View {
        Text("예측 종료")
            .pretendardTextStyle(.Body3Style)
            .foregroundStyle(.gray300)
        
        Text("\(pViewModel.matchPrediction.participant ?? 0)명 참여")
            .pretendardTextStyle(.Body3Style)
            .foregroundStyle(.white0)
    }
    
    /// 팀 이미지&이름 스타일 반환
    private func teamInfo(_ url: String, _ name: String) -> some View {
        VStack(spacing: 6) {
            LoadableImage(image: url)
                .frame(width: 54, height: 54)
            Text(name)
                .pretendardTextStyle(.Caption1Style)
                .foregroundStyle(.white0)
                .frame(width: 54)
        }
    }
    
    /// (퍼센트)% 텍스트 스타일 계산
    @ViewBuilder
    private func percentageTextStyle(_ percentage: Int, isWinner: Bool) -> some View {
        HStack(alignment: .bottom, spacing: 0) {
            Text("\(percentage)")
                .pretendardTextStyle(isWinner ? .H1Style : TextStyle(font: .pretendard(.medium, size: 24), tracking: 0, uiFont: UIFont(name: "Pretendard-Medium", size: 24)!, lineHeight: 30))
                .foregroundStyle(isWinner ? .limeText : .gray300)
                .padding(.trailing, isWinner ? 0 : 2)
            
            Text("%")
                .pretendardTextStyle(.Body1Style)
                .foregroundStyle(isWinner ? .lime : .gray300)
        }
    }
    
    /// % 텍스트 반환
    @ViewBuilder
    private func percentageText() -> some View {
        Text("VS")
            .pretendardTextStyle(.Title2Style)
            .foregroundStyle(.white0)
    }
}

// MARK: - PREVIEW
#Preview("경기 결과 예측") {
    MatchPredictionView(viewModel: MatchCalendarViewModel(), pViewModel: PredictionButtonViewModel())
}