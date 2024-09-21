//
//  StartingLineupPredictionViewModel.swift
//  KickIt
//
//  Created by 이윤지 on 9/13/24.
//

import Foundation
import Combine

/// 선발라인업 예측 화면의 뷰모델
final class StartingLineupPredictionViewModel: StartingLineupPredictionViewModelProtocol {
    /// 홈팀 선수 리스트
    @Published var homeTeamPlayers: [StartingLineupPlayer] = []
    
    /// 원정팀 선수 리스트
    @Published var awayTeamPlayers: [StartingLineupPlayer] = []
    
    /// 사용자가 예측했던 홈팀 선수 리스트
    @Published var homePredictions: UserStartingLineupPrediction?
    
    /// 사용자가 예측했던 원정팀 선수 리스트
    @Published var awayPredictions: UserStartingLineupPrediction?
    
    /// 현재 선택 중인 팀 포메이션
    @Published var selectedFormation: Formation?
    
    /// 현재 선택 중인 팀 포메이션의 배열 순서
    @Published var formationIndex: Int = -1
    
    /// 사용자가 선택한 선수 리스트
    @Published var selectedPlayers: [SoccerPosition : StartingLineupPlayer] = [:]
    
    /// 현재 선택 중인 선수 포지션
    @Published var selectedPositionToInt: Int?
    
    /// 현재 선택 중인 선수 상세 포지션
    @Published var selectedPosition: SoccerPosition?
    
    /// 선수 선택 시트를 띄우기 위한 변수
    @Published var isPlayerPresented: Bool = false
    
    /// 라디오그룹에서 선택한 포지션 아이디
    @Published var selectedRadioBtnID: Int = 0
    
    /// 라디오그룹에서 선택한 포지션 이름 정보
    @Published var selectedPositionName: String?
    
    /// 팀의 선수 리스트
    var teamPlayers: [StartingLineupPlayer] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    /// 선발라인업 예측 조회 API
    func getStartingLineupPrediction(request: StartingLineupPredictionRequest) {
        StartingLineupPredictionAPI.shared.getStartingLineupPrediction(request: request)
            .map { responseDTO in
                let homePlayers = responseDTO.homeTeamPlayers.map { player in
                    StartingLineupPlayer(
                        playerImgURL: player.playerImgURL,
                        playerName: player.playerName,
                        backNum: player.playerNum,
                        playerPosition: player.playerPosition
                    )
                }
                let awayPlayers = responseDTO.awayTeamPlayers.map { player in
                    StartingLineupPlayer(
                        playerImgURL: player.playerImgURL,
                        playerName: player.playerName,
                        backNum: player.playerNum,
                        playerPosition: player.playerPosition
                    )
                }
                var homeTeamPredictions: UserStartingLineupPrediction? = nil
                var awayTeamPredictions: UserStartingLineupPrediction? = nil
                
                if let tempHomePredictions = responseDTO.homeTeamPredictions {
                    homeTeamPredictions = self.startingLineupToEntity(tempHomePredictions)
                }
                if let tempAwayPredictions = responseDTO.awayTeamPredictions {
                    awayTeamPredictions = self.startingLineupToEntity(tempAwayPredictions)
                }
                
                return (homePlayers, awayPlayers, homeTeamPredictions, awayTeamPredictions)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                case .finished:
                    break
                }
            },
                  receiveValue: { [weak self] (homePlayers, awayPlayers, homeTeamPredictions, awayTeamPredictions) in
                self?.homeTeamPlayers = homePlayers
                self?.awayTeamPlayers = awayPlayers
                self?.homePredictions = homeTeamPredictions
                self?.awayPredictions = awayTeamPredictions
            })
            .store(in: &cancellables)
        
    }
    
    /// 선발라인업 예측 조회 중 사용자가 예측했던 선발라인업 선수 리스트를 변환하는 함수(DTO -> Entity)
    private func startingLineupToEntity(_ dto: StartingLineupPredictionsResponse) -> UserStartingLineupPrediction {
        return UserStartingLineupPrediction(
            formation: dto.formation,
            goalkeeper: SoccerPlayer(
                playerImgURL: dto.goalkeeper.playerImgURL,
                playerName: dto.goalkeeper.playerName,
                backNum: dto.goalkeeper.playerNum
            ),
            defenders: dto.defenders.map { player in
                SoccerPlayer(
                    playerImgURL: player.playerImgURL,
                    playerName: player.playerName,
                    backNum: player.playerNum
                )
            },
            midfielders: dto.midfielders.map { player in
                SoccerPlayer(
                    playerImgURL: player.playerImgURL,
                    playerName: player.playerName,
                    backNum: player.playerNum
                )
            },
            strikers: dto.strikers.map { player in
                SoccerPlayer(
                    playerImgURL: player.playerImgURL,
                    playerName: player.playerName,
                    backNum: player.playerNum
                )
            }
        )
    }
    
    /// 포메이션 선택
    func selectFormation(formation: Formation, index: Int) {
        selectedFormation = formation
        formationIndex = index
        selectedPlayers.removeAll() // 포메이션 변경 시, 선수 초기화
    }
    
    /// 포지션에 선수 배치 또는 변경
    func selectPlayer(player: StartingLineupPlayer, position: SoccerPosition) {
        selectedPlayers[position] = player
    }
    
    /// 특정 포지션에 대한 바텀 시트 호출
    func presentPlayerBottomSheet(positionToInt: Int, position: SoccerPosition) {
        selectedPositionToInt = positionToInt
        selectedPosition = position
        isPlayerPresented = true
    }
    
    /// 특정 포지션에 있는 선수 삭제
    func removePlayer(position: SoccerPosition) {
        selectedPlayers[position] = nil
    }
    
    /// 선수 리스트 필터링
    func filteredPlayers() -> [StartingLineupPlayer] {
        // FIXME: 추후, api 연결 완료 시 더미 데이터 로직 삭제하기
        //selectedPosition == 0 ? teamPlayers : teamPlayers.filter { $0.playerPosition == selectedPosition }
        selectedPositionToInt == 0 ? dummyStartingLineupPlayer : dummyStartingLineupPlayer.filter { $0.playerPosition == selectedPositionToInt }
    }
}
