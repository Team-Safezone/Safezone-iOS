//
//  WinningTeamPredictionResult.swift
//  KickIt
//
//  Created by 이윤지 on 11/7/24.
//

import SwiftUI

/// 우승팀 예측 결과 화면
struct ResultWinningTeamPrediction: View {
    /// 상단 카드뷰에 들어갈 데이터 모델
    var prediction: PredictionQuestionModel
    
    /// 뷰모델
    @StateObject var viewModel: ResultWinningTeamPredictionViewModel
    
    init(prediction: PredictionQuestionModel) {
        self.prediction = prediction
        _viewModel = StateObject(wrappedValue: ResultWinningTeamPredictionViewModel(prediction: prediction))
    }
    
    var body: some View {
        ZStack {
            Color(.background)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                // MARK: 상단 질문 카드 뷰
                PredictionQuestionView(predictionType: 0, isRetry: true, matchCode: prediction.matchCode, questionTitle: "우승 팀 예측", question: "이번 경기에서 몇 골을 넣을까?", matchDate: prediction.matchDate, matchTime: prediction.matchTime)
                    .padding(.top, 12)
                
                // MARK: 나의 예측
                Text("나의 예측")
                    .pretendardTextStyle(.Title1Style)
                    .foregroundStyle(.white0)
                    .padding(.top, 24)
                
                HStack(spacing: 13) {
                    // 홈팀
                    predictionView(
                        name: prediction.homeTeamName,
                        score1: viewModel.result.homeTeamScore,
                        score2: viewModel.result.awayTeamScore)
                    
                    // 원정팀
                    predictionView(
                        name: prediction.awayTeamName,
                        score1: viewModel.result.awayTeamScore,
                        score2: viewModel.result.homeTeamScore)
                }
                .padding(.top, 20)
                
                // MARK: 예측 성공 여부
                HStack(spacing: 13) {
                    // 홈팀
                    resultView(viewModel.result.userPrediction)
                    
                    // 원정팀
                    resultView(viewModel.result.userPrediction)
                }
                .padding(.top, 8)
                .padding(.bottom, viewModel.result.userPrediction != nil ? 40 : 100)
                
                // MARK: 평균 예측
                Text("예측 평균")
                    .pretendardTextStyle(.Title1Style)
                    .foregroundStyle(.white0)
                    .padding(.top, 40)
                
                HStack(spacing: 13) {
                    // 홈팀
                    predictionView(
                        name: prediction.homeTeamName,
                        score1: viewModel.result.avgHomeTeamScore,
                        score2: viewModel.result.avgAwayTeamScore)
                    
                    // 원정팀
                    predictionView(
                        name: prediction.awayTeamName,
                        score1: viewModel.result.avgAwayTeamScore,
                        score2: viewModel.result.avgHomeTeamScore)
                }
                .padding(.top, 20)
                
                // MARK: 예측 성공 여부
                HStack(spacing: 13) {
                    // 홈팀
                    resultView(viewModel.result.userPrediction)
                    
                    // 원정팀
                    resultView(viewModel.result.userPrediction)
                }
                .padding(.top, 8)
                
                Spacer()
            } //: VSTACK
            .padding(.horizontal, 16)
        }
        .navigationTitle("우승팀 예측")
    }
    
    /// 실제 예측 지표 뷰
    @ViewBuilder
    private func predictionView(name: String, score1: Int?, score2: Int?) -> some View {
        VStack(spacing: 10) {
            HStack(spacing: 4) {
                Text(name)
                    .pretendardTextStyle(.SubTitleStyle)
                    .foregroundStyle(.white0)
                Text(viewModel.whoIsWinner(score1, score2).0)
                    .pretendardTextStyle(.SubTitleStyle)
                    .foregroundStyle(viewModel.whoIsWinner(score1, score2).2)
            }
            Text(viewModel.isParticipated(score1))
                .pretendardTextStyle(.H2Style)
                .foregroundStyle(score1 == nil ? .gray500 : .white0)
        }
        .padding(.vertical, 22)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(.gray950)
        )
    }
    
    /// 예측 성공 여부 뷰
    @ViewBuilder
    private func resultView(_ isPredicted: Bool?) -> some View {
        VStack(spacing: 4) {
            if let predict = isPredicted {
                if predict {
                    Image(uiImage: .circle)
                        .foregroundStyle(.lime)
                    Text("성공")
                        .pretendardTextStyle(.Body2Style)
                        .foregroundStyle(.limeText)
                }
                else {
                    Image(uiImage: .nope)
                        .foregroundStyle(.gray500)
                    Text("실패")
                        .pretendardTextStyle(.Body2Style)
                        .foregroundStyle(.gray500)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ResultWinningTeamPrediction(prediction: dummyPredictionQuestionModel)
}
