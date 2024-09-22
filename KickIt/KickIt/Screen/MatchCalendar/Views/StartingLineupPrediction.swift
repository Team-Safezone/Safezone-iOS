//
//  StartingLineupPrediction.swift
//  KickIt
//
//  Created by 이윤지 on 9/16/24.
//

import SwiftUI

/// 선발라인업 예측 화면
struct StartingLineupPrediction: View {
    // MARK: - PROPERTY
    /// 축구 경기 객체
    var soccerMatch: SoccerMatch
    
    /// 선발라인업 예측 뷰모델 객체
    @StateObject var viewModel = StartingLineupPredictionViewModel()
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            // 배경 색상
            Color(.backgroundDown)
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // 선발라인업 예측 질문 뷰
                    PredictionQuestionView(
                        matchCode: soccerMatch.matchCode,
                        questionTitle: "선발 라인업 예측",
                        question: "이번 경기에서 어떤 선발 라인업을 구성할까?",
                        endDate: soccerMatch.matchDate,
                        endTime: soccerMatch.matchTime
                    )
                    
                    // 홈팀의 선발라인업 선택
                    StartingLineupPredictionView(
                        viewModel: viewModel,
                        isHomeTeam: true,
                        team: soccerMatch.homeTeam
                    )
                    .padding(.top, 20)
                    
                    // 원정팀의 선발라인업 선택
                    StartingLineupPredictionView(
                        viewModel: viewModel,
                        isHomeTeam: false,
                        team: soccerMatch.awayTeam
                    )
                    .padding(.top, 20)
                    
                    // 예측하기 버튼
                    DesignWideButton(
                        label: "예측하기",
                        labelColor: viewModel.areBothLineupsComplete() ? .blackInAssets : .blackInAssets.opacity(0.5),
                        btnBGColor: .lime
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(viewModel.areBothLineupsComplete() ? .clear : .blackInAssets)
                            .opacity(viewModel.areBothLineupsComplete() ? 0 : 0.5)
                    )
                    .disabled(!viewModel.areBothLineupsComplete()) // 선발라인업 선택이 완료되지 않았다면 비활성화
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
                .padding(.horizontal, 16)
            }
            .scrollIndicators(.hidden)
        }
        .onAppear {
            // 화면 진입 시, 선발라인업 예측 조회 API 호출
            viewModel.getStartingLineupPrediction(request: StartingLineupPredictionRequest(matchId: soccerMatch.id))
        }
        // 툴 바, 상태 바 설정
        .navigationTitle("선발 라인업 예측")
        .ignoresSafeArea(edges: .bottom)
        .toolbarBackground(Color.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
    
    // MARK: - FUNCTION
}

// MARK: - PREVIEW
#Preview("선발 라인업 예측") {
    StartingLineupPrediction(soccerMatch: dummySoccerMatches[2])
}
