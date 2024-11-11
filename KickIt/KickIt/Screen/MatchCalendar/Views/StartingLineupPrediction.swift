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
    
    /// 선발라인업 예측 성공 여부
    @State private var isSuccess: Bool = false
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            // 배경 색상
            Color(.backgroundDown)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // MARK: 선발라인업 예측 질문 뷰
                    PredictionQuestionView(
                        predictionType: 1,
                        isRetry: false,
                        matchCode: soccerMatch.matchCode,
                        questionTitle: "선발 라인업 예측",
                        question: "이번 경기에서 어떤 선발 라인업을 구성할까?",
                        matchDate: soccerMatch.matchDate,
                        matchTime: soccerMatch.matchTime
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
                        // 선발라인업 예측 API 호출
                        let homeGK = homeSelectedPlayers[.GK]
                        let dfPlayerRequests = matchSoccerPlayerRequests(from: dfPositions, selectedPlayers: homeSelectedPlayers)
                        let mfPlayerRequests = matchSoccerPlayerRequests(from: mfPositions, selectedPlayers: homeSelectedPlayers)
                        let fwPlayerRequests = matchSoccerPlayerRequests(from: fwPositions, selectedPlayers: homeSelectedPlayers)
                        
                        let awayGK = awaySelectedPlayers[.GK]
                        let dfPlayerRequests2 = matchSoccerPlayerRequests(from: dfPositions, selectedPlayers: awaySelectedPlayers)
                        let mfPlayerRequests2 = matchSoccerPlayerRequests(from: mfPositions, selectedPlayers: awaySelectedPlayers)
                        let fwPlayerRequests2 = matchSoccerPlayerRequests(from: fwPositions, selectedPlayers: awaySelectedPlayers)
                        
                        // 선발라인업 예측 API 호출
                        viewModel.postStartingLineup(
                            query: MatchIdRequest(matchId: soccerMatch.id),
                            request: StartingLineupPredictionRequest(
                                homeFormation: homeFormationIndex,
                                awayFormation: awayFormationIndex,
                                homeGoalkeeper: [SoccerPlayerRequest(playerName: homeGK!.playerName, playerNum: homeGK!.backNum)],
                                homeDefenders: dfPlayerRequests,
                                homeMidfielders: mfPlayerRequests,
                                homeStrikers: fwPlayerRequests,
                                awayGoalkeeper: [SoccerPlayerRequest(playerName: awayGK!.playerName, playerNum: awayGK!.backNum)],
                                awayDefenders: dfPlayerRequests2,
                                awayMidfielders: mfPlayerRequests2,
                                awayStrikers: fwPlayerRequests2)) { success in
                                    if success {
                                        self.isSuccess = success
                                        print("선발라인업 예측하기 API 호출 완료")
                                    }
                                }
                    } label: {
                        DesignWideButton(
                            label: "예측하기",
                            labelColor: viewModel.areBothLineupsComplete(home: homeSelectedPlayers, away: awaySelectedPlayers) ? .blackAssets : .gray400,
                            btnBGColor: viewModel.areBothLineupsComplete(home: homeSelectedPlayers, away: awaySelectedPlayers) ? .lime : .gray600
                        )
                    }
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
            viewModel.getDefaultStartingLineupPrediction(request: MatchIdRequest(matchId: soccerMatch.id))
        }
        // 툴 바, 상태 바 설정
        .navigationTitle("선발 라인업 예측")
        .navigationDestination(isPresented: $isSuccess) {
            // API 호출에 성공했을 경우, 선발라인업 예측 성공 화면으로 이동
        }
    }
    
    // MARK: - FUNCTION
    /// 사용자가 선택한 선수 리스트를 Request 모델로 바꾸는 함수
    func matchSoccerPlayerRequests(from positions: [SoccerPosition], selectedPlayers: [SoccerPosition: StartingLineupPlayer]) -> [SoccerPlayerRequest] {
        return positions.compactMap { position -> SoccerPlayerRequest? in
            if let player = selectedPlayers[position] {
                return SoccerPlayerRequest(playerName: player.playerName, playerNum: player.backNum)
            }
            return nil
        }
    }
}

// MARK: - PREVIEW
#Preview("선발 라인업 예측") {
    StartingLineupPrediction(soccerMatch: dummySoccerMatches[2])
}
