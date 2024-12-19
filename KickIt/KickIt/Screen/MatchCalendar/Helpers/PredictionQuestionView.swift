//
//  PredictionQuestion.swift
//  KickIt
//
//  Created by 이윤지 on 9/16/24.
//

import SwiftUI

/// 예측화면에서 사용되는 질문 화면
struct PredictionQuestionView: View {
    // MARK: - PROPERTY
    /// 예측 유형
    var predictionType: Int // 0: 우승팀 예측, 1: 선발라인업 예측
    
    /// 예측 다시하기 여부
    var isRetry: Bool
    
    /// 경기 코드
    var matchCode: Int
    
    /// 질문 타이틀
    var questionTitle: String
    
    /// 질문
    var question: String
    
    /// 경기 종료 날짜
    var matchDate: Date
    
    /// 경기 종료 시간
    var matchTime: Date
    
    /// 예측에 참여한 사람 수
    var predictionUserNum: Int? = 0
    
    /// 결과 화면에서 사용하는 지에 대한 여부
    var isResult: Bool
    
    /// 타이머 뷰모델
    @ObservedObject var timerViewModel: TimerViewModel
    
    // MARK: - BODY
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 예측 질문 타이틀
            Text("Q. \(questionTitle)")
                .pretendardTextStyle(.SubTitleStyle)
                .foregroundStyle(.gray500Text)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // 예측 질문
            Text(question)
                .pretendardTextStyle(.Title1Style)
                .foregroundStyle(.white0)
                .padding(.top, 2)
            
            // 예측 종료 타이머 or 예측에 참여한 사람 수
            HStack(spacing: 4) {
                // 결과 화면이라면
                if isResult {
                    // 우승팀 예측 진행 중이라면 or 선발라인업 예측 진행 중이라면
                    if !timerViewModel.isWinningTeamPredictionFinished || !timerViewModel.isLineupPredictionFinished {
                        Text("예측 진행중")
                            .pretendardTextStyle(.SubTitleStyle)
                            .foregroundStyle(.limeText)
                    }
                    else {
                        Text("예측 종료")
                            .pretendardTextStyle(.SubTitleStyle)
                            .foregroundStyle(.gray300)
                    }
                    Text("\(predictionUserNum ?? 0)명 참여")
                        .pretendardTextStyle(.Body3Style)
                        .foregroundStyle(.white0)
                }
                // 예측 화면이라면
                else {
                    Text(isPredictFinished() ? "예측 종료" : "예측 진행중")
                        .pretendardTextStyle(.SubTitleStyle)
                        .foregroundStyle(isPredictFinished() ? .gray300 : .limeText)
                    
                    /// 우승팀 예측인 경우
                    if predictionType == 0 {
                        Text(isPredictFinished() ? "\(predictionUserNum ?? 0)명 참여" : timerViewModel.winningTeamEndTime)
                            .pretendardTextStyle(.Body3Style)
                            .foregroundStyle(.white0)
                    }
                    else {
                        Text(isPredictFinished() ? "\(predictionUserNum ?? 0)명 참여" : timerViewModel.lineupEndTime)
                            .pretendardTextStyle(.Body3Style)
                            .foregroundStyle(.white0)
                    }
                }
                
                Spacer()
                
                // 예측 다시하기의 경우라면
                if isRetry {
                    Button {
                        
                    } label: {
                        Text("다시하기")
                            .font(.pretendard(.medium, size: 13))
                            .foregroundStyle(.gray500Text)
                            .underline()
                    }
                }
            }
            .padding(.top, 8)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.gray950)
        )
    }
    
    // MARK: - FUNCTION
    /// 예측 종료 여부
    private func isPredictFinished() -> Bool {
        if timerViewModel.isWinningTeamPredictionFinished || timerViewModel.isLineupPredictionFinished {
            return true
        }
        else {
            return false
        }
    }
}

// MARK: - PREVIEW
#Preview("예측 질문") {
    PredictionQuestionView(
        predictionType: 0,
        isRetry: false,
        matchCode: 0,
        questionTitle: "예측",
        question: "질문?",
        matchDate: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 27))!,
        matchTime: Calendar.current.date(from: DateComponents(hour: 12, minute: 55))!, isResult: false,
        timerViewModel: TimerViewModel()
    )
}
