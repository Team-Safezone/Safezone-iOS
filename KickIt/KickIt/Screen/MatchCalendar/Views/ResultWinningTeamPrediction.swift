//
//  WinningTeamPredictionResult.swift
//  KickIt
//
//  Created by 이윤지 on 11/7/24.
//

import SwiftUI

/// 우승팀 예측 결과 화면
struct ResultWinningTeamPrediction: View {
    /// 1번 뒤로가기
    let popToOne: () -> Void
    
    /// 3번 뒤로가기
    let popToThreeStep: () -> Void
    
    /// 상단 카드뷰에 들어갈 데이터 모델
    var prediction: PredictionQuestionModel
    
    /// 뒤로가기 여부
    var isOneBack: Bool
    
    /// 뷰모델
    @StateObject var viewModel: ResultWinningTeamPredictionViewModel
    
    /// 타이머 뷰모델
    @StateObject var timerViewModel = TimerViewModel()
    
    init(popToOne: @escaping () -> Void, popToThreeStep: @escaping () -> Void, prediction: PredictionQuestionModel, isOneBack: Bool) {
        self.popToOne = popToOne
        self.popToThreeStep = popToThreeStep
        self.prediction = prediction
        self.isOneBack = isOneBack
        _viewModel = StateObject(wrappedValue: ResultWinningTeamPredictionViewModel(prediction: prediction))
    }
    
    var body: some View {
        ZStack {
            Color(.backgroundDown)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                // MARK: 네비게이션 바
                ZStack {
                    // 중앙에 위치한 텍스트
                    Text("우승 팀 예측")
                        .font(.pretendard(.semibold, size: 16))
                        .foregroundStyle(.white0)
                    
                    // 좌측 상단에 위치한 뒤로가기 버튼
                    HStack {
                        Button {
                            if isOneBack {
                                popToOne()
                                print("뒤로가기 one back")
                            }
                            else {
                                popToThreeStep()
                                print("뒤로가기 two back")
                            }
                        } label: {
                            Image(uiImage: .back)
                                .foregroundStyle(.white0)
                        }
                        .padding(.leading, -16)
                        
                        Spacer() // 오른쪽으로 공간 밀어내기
                    }
                    .padding(.leading) // 버튼을 좌측에 고정시키기 위해 여백 조정
                }
                
                // MARK: 상단 질문 카드 뷰
                PredictionQuestionView(predictionType: 0, isRetry: true, matchCode: prediction.matchCode, questionTitle: "우승 팀 예측", question: "이번 경기에서 몇 골을 넣을까?", matchDate: prediction.matchDate, matchTime: prediction.matchTime, predictionUserNum: viewModel.result.participant, isResult: true, timerViewModel: timerViewModel)
                    .padding(.top, 12)
                    .padding(.horizontal, 16)
                
                // MARK: 나의 예측
                Text("나의 예측")
                    .pretendardTextStyle(.Title1Style)
                    .foregroundStyle(.white0)
                    .padding(.top, 24)
                    .padding(.horizontal, 16)
                
                HStack(spacing: 13) {
                    // 홈팀
                    predictionView(
                        name: prediction.homeTeam.teamName,
                        score1: viewModel.result.homeTeamScore,
                        score2: viewModel.result.awayTeamScore)
                    
                    // 원정팀
                    predictionView(
                        name: prediction.awayTeam.teamName,
                        score1: viewModel.result.awayTeamScore,
                        score2: viewModel.result.homeTeamScore)
                }
                .padding(.top, 20)
                .padding(.horizontal, 16)
                
                // MARK: 예측 성공 여부
                HStack(spacing: 13) {
                    // 홈팀
                    resultView(viewModel.result.userPrediction)
                    
                    // 원정팀
                    resultView(viewModel.result.userPrediction)
                }
                .padding(.top, 8)
                .padding(.bottom, viewModel.result.userPrediction != nil ? 40 : 100)
                .padding(.horizontal, 16)
                
                // MARK: 평균 예측
                Text("예측 평균")
                    .pretendardTextStyle(.Title1Style)
                    .foregroundStyle(.white0)
                    .padding(.top, 40)
                    .padding(.horizontal, 16)
                
                HStack(spacing: 13) {
                    // 홈팀
                    predictionView(
                        name: prediction.homeTeam.teamName,
                        score1: viewModel.result.avgHomeTeamScore,
                        score2: viewModel.result.avgAwayTeamScore)
                    
                    // 원정팀
                    predictionView(
                        name: prediction.awayTeam.teamName,
                        score1: viewModel.result.avgAwayTeamScore,
                        score2: viewModel.result.avgHomeTeamScore)
                }
                .padding(.top, 20)
                .padding(.horizontal, 16)
                
                // MARK: 예측 성공 여부
                HStack(spacing: 13) {
                    // 홈팀
                    resultView(viewModel.result.userPrediction)
                    
                    // 원정팀
                    resultView(viewModel.result.userPrediction)
                }
                .padding(.top, 8)
                .padding(.horizontal, 16)
                
                Spacer()
            } //: VSTACK
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            timerViewModel.winningTeamPredictionTimer(matchDate: prediction.matchDate, matchTime: prediction.matchTime, format: 1)
            timerViewModel.startLineupPredictionTimer(matchDate: prediction.matchDate, matchTime: prediction.matchTime, format: 1)
        }
        .onDisappear {
            timerViewModel.stopWinningTeamTimer()
            timerViewModel.stopLineupPredictionTimer()
        }
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
}

#Preview {
    ResultWinningTeamPrediction(popToOne: {}, popToThreeStep: {}, prediction: dummyPredictionQuestionModel, isOneBack: false)
}
