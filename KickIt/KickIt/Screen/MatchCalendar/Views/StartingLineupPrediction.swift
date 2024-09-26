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
    @ObservedObject var viewModel = StartingLineupPredictionViewModel()
    
    /// 현재 선택 중인 홈팀 선수 리스트
    @State var homeSelectedPlayers: [SoccerPosition : StartingLineupPlayer] = [:]
    
    /// 현재 선택 중인 원정팀 선수 리스트
    @State var awaySelectedPlayers: [SoccerPosition : StartingLineupPlayer] = [:]
    
    /// 현재 선택 중인 홈팀 포메이션 배열 순서
    @State var homeFormationIndex: Int = -1
    
    /// 현재 선택 중인 원정팀 포메이션 배열 순서
    @State var awayFormationIndex: Int = -1
    
    /// 수비수 포지션 배열
    private let dfPositions: [SoccerPosition] = [.DF1, .DF2, .DF3, .DF4]
    
    /// 미드필더 포지션 배열
    private let mfPositions: [SoccerPosition] = [.MF1, .MF2, .MF3, .MF4, .MF5]
    
    /// 공격수 포지션 배열
    private let fwPositions: [SoccerPosition] = [.FW1, .FW2, .FW3]
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            // 배경 색상
            Color(.backgroundDown)
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // MARK: 선발라인업 예측 질문 뷰
                    PredictionQuestionView(
                        matchCode: soccerMatch.matchCode,
                        questionTitle: "선발 라인업 예측",
                        question: "이번 경기에서 어떤 선발 라인업을 구성할까?",
                        endDate: soccerMatch.matchDate,
                        endTime: soccerMatch.matchTime
                    )
                    
                    // MARK: 홈팀의 선발라인업 선택
                    StartingLineupPredictionView(
                        isHomeTeam: true,
                        team: soccerMatch.homeTeam,
                        selectedPlayers: $homeSelectedPlayers,
                        formationIndex: $homeFormationIndex
                    )
                    .padding(.top, 20)
                    
                    // MARK: 원정팀의 선발라인업 선택
                    StartingLineupPredictionView(
                        isHomeTeam: false,
                        team: soccerMatch.awayTeam,
                        selectedPlayers: $awaySelectedPlayers,
                        formationIndex: $awayFormationIndex
                    )
                    .padding(.top, 20)
                    
                    // MARK: 예측하기 버튼
                    Button {
                        print("홈팀 포메이션: \(homeFormationIndex)")
                        print("홈팀 골기퍼: \(String(describing: homeSelectedPlayers[.GK]?.playerName))")
                        
                        let dfPlayers = dfPositions.compactMap { position in
                            homeSelectedPlayers[position]?.playerName
                        }
                        print("홈팀 수비수: \(String(describing: dfPlayers))")
                        
                        let mfPlayers = mfPositions.compactMap { position in
                            homeSelectedPlayers[position]?.playerName
                        }
                        print("홈팀 미드필더: \(String(describing: mfPlayers))")
                        
                        let fwPlayers = fwPositions.compactMap { position in
                            homeSelectedPlayers[position]?.playerName
                        }
                        print("홈팀 공격수: \(String(describing: fwPlayers))")
                        
                        print("----------------------------------")
                        print("원정팀 포메이션: \(awayFormationIndex)")
                        print("원정팀 골기퍼: \(String(describing: awaySelectedPlayers[.GK]?.playerName))")
                        
                        let dfPlayers2 = dfPositions.compactMap { position in
                            awaySelectedPlayers[position]?.playerName
                        }
                        print("원정팀 수비수: \(String(describing: dfPlayers2))")
                        
                        let mfPlayers2 = mfPositions.compactMap { position in
                            awaySelectedPlayers[position]?.playerName
                        }
                        print("원정팀 미드필더: \(String(describing: mfPlayers2))")
                        
                        let fwPlayers2 = fwPositions.compactMap { position in
                            awaySelectedPlayers[position]?.playerName
                        }
                        print("원정팀 공격수: \(String(describing: fwPlayers2))")
                    } label: {
                        DesignWideButton(
                            label: "예측하기",
                            labelColor: viewModel.areBothLineupsComplete(home: homeSelectedPlayers, away: awaySelectedPlayers) ? .blackAssets : .blackAssets.opacity(0.5),
                            btnBGColor: .lime
                        )
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(viewModel.areBothLineupsComplete(home: homeSelectedPlayers, away: awaySelectedPlayers) ? .clear : .blackAssets)
                            .opacity(viewModel.areBothLineupsComplete(home: homeSelectedPlayers, away: awaySelectedPlayers) ? 0 : 0.5)
                    )
                    // 선발라인업 선택이 완료되지 않았다면 비활성화
                    .disabled(!viewModel.areBothLineupsComplete(home: homeSelectedPlayers, away: awaySelectedPlayers))
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
