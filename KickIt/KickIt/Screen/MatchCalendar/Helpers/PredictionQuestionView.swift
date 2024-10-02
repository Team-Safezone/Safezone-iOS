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
    /// 경기 코드
    var matchCode: Int
    
    /// 질문 타이틀
    var questionTitle: String
    
    /// 질문
    var question: String
    
    /// 예측 종료 날짜
    var endDate: Date
    
    /// 예측 종료 시간
    var endTime: Date
    
    /// 예측에 참여한 사람 수
    var predictionUserNum: Int? = 0
    
    /// 현재 날짜 및 시간
    @State private var nowDate = Date()
    
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
                .padding(.top, 4)
            
            // 예측 종료 타이머 or 예측에 참여한 사람 수
            HStack(spacing: 4) {
                Text(matchCode == 0 ? "예측 진행중" : "예측 종료")
                    .pretendardTextStyle(.Caption1Style)
                    .foregroundStyle(matchCode == 0 ? .lime : .gray300)
                
                Text(matchCode == 0 ? timePredictionInterval(nowDate: nowDate, matchDate: endDate, matchTime: endTime): "\(predictionUserNum ?? 0)명 참여")
                    .pretendardTextStyle(.Caption1Style)
                    .foregroundStyle(.white0)
                    .onAppear {
                        startTimer()
                    }
            }
            .padding(.top, 10)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.gray950)
        )
    }
    
    // MARK: - FUNCTION
    /// 예측 종료 마감까지의 시간 계산
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.nowDate = Date()
        }
    }
}

// MARK: - PREVIEW
#Preview("예측 질문") {
    PredictionQuestionView(
        matchCode: 0,
        questionTitle: "예측",
        question: "질문?",
        endDate: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 31))!,
        endTime: Calendar.current.date(from: DateComponents(hour: 20, minute: 30))!
    )
}
