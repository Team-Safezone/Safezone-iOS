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
    
    /// 현재 선택 중인 홈팀 포메이션
    @Published var homeSelectedFormation: Formation?
    
    /// 현재 선택 중인 원정팀 포메이션
    @Published var awaySelectedFormation: Formation?
    
    /// 현재 선택 중인 홈팀 포메이션의 배열 순서
    @Published var homeFormationIndex: Int = -1
    
    /// 현재 선택 중인 원정팀 포메이션의 배열 순서
    @Published var awayFormationIndex: Int = -1
    
    /// 사용자가 선택한 홈팀 선수 리스트
    @Published var homeSelectedPlayers: [SoccerPosition : StartingLineupPlayer] = [:]
    
    /// 사용자가 선택한 원정팀 선수 리스트
    @Published var awaySelectedPlayers: [SoccerPosition : StartingLineupPlayer] = [:]
    
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
    
    /// 포메이션 이름 반환
    func presentFormationInfo(isHomeTeam: Bool) -> String {
        if isHomeTeam {
            homeFormationIndex == -1 ? "포메이션 선택" : formations[homeFormationIndex].name
        }
        else {
            awayFormationIndex == -1 ? "포메이션 선택" : formations[awayFormationIndex].name
        }
    }
    
    /// 포메이션 선택
    func selectFormation(formation: Formation, index: Int, isHomeTeam: Bool) {
        if isHomeTeam {
            homeSelectedFormation = formation
            homeFormationIndex = index
            homeSelectedPlayers.removeAll() // 포메이션 변경 시, 선수 초기화
        }
        else {
            awaySelectedFormation = formation
            awayFormationIndex = index
            awaySelectedPlayers.removeAll()
        }
    }
    
    /// 포지션에 선수 배치 또는 변경
    func selectPlayer(player: StartingLineupPlayer, position: SoccerPosition, isHomeTeam: Bool) {
        if isHomeTeam {
            homeSelectedPlayers[position] = player
            print("홈팀 선수 리스트", homeSelectedPlayers.values)
        }
        else {
            awaySelectedPlayers[position] = player
            print("원정팀 선수 리스트", awaySelectedPlayers.values)
        }
    }
    
    /// 특정 포지션에 대한 바텀 시트 호출
    func presentPlayerBottomSheet(positionToInt: Int, position: SoccerPosition) {
        selectedPositionToInt = positionToInt
        selectedPosition = position
        
        let positionMapping: [Int: (String, Int)] = [
            1: ("골키퍼", 0),
            2: ("수비수", 1),
            3: ("미드필더", 2),
            4: ("공격수", 3)
        ]
        let positionInfo = positionMapping[selectedPositionToInt!] ?? ("골기퍼", 1)
        selectedPositionName = positionInfo.0
        selectedRadioBtnID = positionInfo.1
        
        isPlayerPresented = true
    }
    
    /// 특정 포지션에 있는 선수 삭제
    func removePlayer(position: SoccerPosition, isHomeTeam: Bool) {
        if isHomeTeam {
            homeSelectedPlayers[position] = nil
        }
        else {
            awaySelectedPlayers[position] = nil
        }
    }
    
    /// 선수 리스트 필터링
    func filteredPlayers() -> [StartingLineupPlayer] {
        // FIXME: 추후, api 연결 완료 시 더미 데이터 로직 삭제하기
        // teamPlayers.filter { $0.playerPosition == selectedPosition }
        return dummyStartingLineupPlayer.filter { $0.playerPosition == selectedPositionToInt }
    }
    
    /// 라디오 그룹에서 포지션 클릭 시 반영
    func selectPosition() {
        let positionMapping: [String: Int] = [
            "골키퍼": 1,
            "수비수": 2,
            "미드필더": 3,
            "공격수": 4
        ]

        selectedPositionToInt = positionMapping[selectedPositionName ?? "골기퍼"] ?? 1
    }
    
    /// 각 팀의 라인업 완성 여부를 확인하는 함수
    func isLineupComplete(isHomeTeam: Bool) -> Bool {
        // 사용자가 선택한 선수 개수
        let selectedPlayers = isHomeTeam ? homeSelectedPlayers.count : awaySelectedPlayers.count
        return selectedPlayers == 11
    }
    
    /// 홈팀과 원정팀의 선발라인업 완성 여부
    func areBothLineupsComplete() -> Bool {
        return isLineupComplete(isHomeTeam: true) && isLineupComplete(isHomeTeam: false)
    }
}
