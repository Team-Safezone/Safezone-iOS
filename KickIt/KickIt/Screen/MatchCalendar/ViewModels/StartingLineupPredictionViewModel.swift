//
//  StartingLineupPredictionViewModel.swift
//  KickIt
//
//  Created by 이윤지 on 9/13/24.
//

import Foundation
import Combine

/// 선발라인업 예측 화면의 뷰모델
final class StartingLineupPredictionViewModel: ObservableObject {
    /// 홈팀 전체 선수 리스트
    @Published var homeTeamPlayers: [StartingLineupPlayer] = []
    
    /// 원정팀 전체 선수 리스트
    @Published var awayTeamPlayers: [StartingLineupPlayer] = []
    
    /// 사용자가 예측했던 홈팀 선수 리스트
    @Published var homePredictions: UserStartingLineupPrediction?
    
    /// 사용자가 예측했던 원정팀 선수 리스트
    @Published var awayPredictions: UserStartingLineupPrediction?
    
    /// 등급
    @Published var grade: Int = 0
    
    /// 포인트
    @Published var point: Int = 0
    
    /// 현재 선택 중인 팀 포메이션
    @Published var selectedFormation: Formation?
    
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
    
    /// 선발라인업 예측 API
    func postStartingLineup(query: MatchIdRequest, request: StartingLineupPredictionRequest, completion: @escaping (Bool) -> (Void)) {
        StartingLineupPredictionAPI.shared.postStartingLineupPrediction(query: query, request: request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { complete in
                switch complete {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    completion(false)
                case .finished:
                    break
                }
            },
            receiveValue: { [weak self] dto in
                self?.grade = dto.grade
                self?.point = dto.point
                completion(true)
            })
            .store(in: &cancellables)
    }
    
    /// 선발라인업 예측 조회 API
    func getDefaultStartingLineupPrediction(request: MatchIdRequest) {
        StartingLineupPredictionAPI.shared.getDefaultStartingLineupPrediction(request: request)
            .map { responseDTO in
                let homePlayers = responseDTO.homePlayers.map { player in
                    StartingLineupPlayer(
                        playerImgURL: player.playerImgURL,
                        playerName: player.playerName,
                        backNum: player.playerNum,
                        playerPosition: player.playerPos
                    )
                }
                let awayPlayers = responseDTO.awayPlayers.map { player in
                    StartingLineupPlayer(
                        playerImgURL: player.playerImgURL,
                        playerName: player.playerName,
                        backNum: player.playerNum,
                        playerPosition: player.playerPos
                    )
                }
                var homePrediction: UserStartingLineupPrediction? = nil
                var awayPrediction: UserStartingLineupPrediction? = nil
                
                if let tempHomePrediction = responseDTO.homePrediction {
                    homePrediction = self.startingLineupToEntity(tempHomePrediction)
                }
                if let tempAwayPrediction = responseDTO.awayPrediction {
                    awayPrediction = self.startingLineupToEntity(tempAwayPrediction)
                }
                
                return (homePlayers, awayPlayers, homePrediction, awayPrediction)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { complete in
                switch complete {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                case .finished:
                    break
                }
            },
            receiveValue: { [weak self] (homePlayers, awayPlayers, homeTeamPrediction, awayTeamPrediction) in
                self?.homeTeamPlayers = homePlayers
                self?.awayTeamPlayers = awayPlayers
                self?.homePredictions = homeTeamPrediction
                self?.awayPredictions = awayTeamPrediction
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
    func presentFormationInfo(formationIndex: Int) -> String {
        formationIndex == -1 ? "포메이션 선택" : formations[formationIndex].name
    }
    
    /// 포메이션 선택
    func selectFormation(formation: Formation) {
        selectedFormation = formation
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
    
    /// 이미 선택된 선수인지 확인하는 함수
    func isPlayerAlreadySelected(selectedPlayers: [SoccerPosition:StartingLineupPlayer], player: StartingLineupPlayer) -> Bool {
        return selectedPlayers.contains(where: { $0.value.backNum == player.backNum }) // 등번호로 비교
    }
    
    /// 특정 포지션에 있는 선수 삭제
//    func removePlayer(position: SoccerPosition) {
//        selectedPlayers[position] = nil
//    }
    
    /// 선수 리스트 필터링
    func filteredPlayers(_ isHomeTeam: Bool) -> [StartingLineupPlayer] {
        if isHomeTeam {
            return homeTeamPlayers.filter { $0.playerPosition == selectedPositionToInt }
        }
        else {
            return awayTeamPlayers.filter { $0.playerPosition == selectedPositionToInt }
        }
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
    func isLineupComplete(selectedPlayers: [SoccerPosition:StartingLineupPlayer]) -> Bool {
        // 사용자가 선택한 선수 개수
        let selectedPlayers = selectedPlayers.count
        return selectedPlayers == 11
    }
    
    /// 홈팀과 원정팀의 선발라인업 완성 여부
    func areBothLineupsComplete(home: [SoccerPosition:StartingLineupPlayer], away: [SoccerPosition:StartingLineupPlayer]) -> Bool {
        return isLineupComplete(selectedPlayers: home) && isLineupComplete(selectedPlayers: away)
    }
}
