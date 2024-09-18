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
}
