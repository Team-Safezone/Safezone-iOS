//
//  StartingLineupViewModel.swift
//  KickIt
//
//  Created by 이윤지 on 10/9/24.
//

import Foundation
import Combine

/// 선발라인업 조회 뷰모델
// FIXME: 프로토타입 발표 이후, default 값들 삭제하기!!
final class StartingLineupViewModel: ObservableObject {
    /// 경기 id
    private var matchId: Int64?
    
    /// 홈팀 포메이션
    @Published var homeFormation: String = "4-2-3-1"
    
    /// 원정팀 포메이션
    @Published var awayFormation: String = "5-3-2"
    
    /// 홈팀 포메이션 배열
    @Published var homeFormations: [Int] = []
    
    /// 원정팀 포메이션 배열
    @Published var awayFormations: [Int] = []
    
    /// 홈팀 선발라인업
    @Published var homeLineups: StartingLineupModel?
    
    /// 원정팀 선발라인업
    @Published var awayLineups: StartingLineupModel?
    
    /// 홈팀 후보선수
    @Published var homeSubstitutes: [SubstituteModel] = [SubstituteModel(playerName: "선수1", playerNum: 1), SubstituteModel(playerName: "선수2", playerNum: 2), SubstituteModel(playerName: "선수3", playerNum: 3), SubstituteModel(playerName: "선수4", playerNum: 4)]
    
    /// 원정팀 후보선수
    @Published var awaySubstitutes: [SubstituteModel] = [SubstituteModel(playerName: "손흥민", playerNum: 7)]
    
    /// 홈팀 감독 이름
    @Published var homeDirector: String = "엔초 마레스카"
    
    /// 원정팀 감독 이름
    @Published var awayDirector: String = "안지 포스테코글루"
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(matchId: Int64?) {
        self.matchId = matchId
        if let matchId = matchId {
            getStartingLineup(request: MatchIdRequest(matchId: matchId))
        }
        
        self.homeLineups = StartingLineupModel(goalkeeper: dummyGoalkeeper, defenders: dummyDF1, midfielders: dummyMF1, midfielders2: dummyMF2, strikers: dummyST1)
        self.awayLineups = StartingLineupModel(goalkeeper: dummyGoalkeeper, defenders: dummyDF2, midfielders: dummyMF3, strikers: dummyST2)
    }
    
    /// 선발라인업 조회
    private func getStartingLineup(request: MatchIdRequest) {
        MatchCalendarAPI.shared.getStartingLineup(request: request)
            .map { dto in
                let homeFormation = dto.homeFormation
                let awayFormation = dto.awayFormation
                
                let homeFormations = self.formationToEntity(dto.homeFormation)
                let awayFormations = self.formationToEntity(dto.awayFormation)
                
                let homeLineups = self.lineupToEntity(dto.homeLineups)
                let awayLineups = self.lineupToEntity(dto.awayLineups)
                
                let homeSubstitutes = self.substituteToEntity(dto.homeSubstitutes)
                let awaySubstitutes = self.substituteToEntity(dto.awaySubstitutes)
                
                let homeDirector = dto.homeDirector
                let awayDirector = dto.awayDirector
                
                return (homeFormation, awayFormation, homeFormations, awayFormations, homeLineups, awayLineups, homeSubstitutes, awaySubstitutes, homeDirector, awayDirector)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] (homeFormation, awayFormation, homeFormations, awayFormations, homeLineups, awayLineups, homeSubstitutes, awaySubstitutes, homeDirector, awayDirector) in
                self?.homeFormation = homeFormation
                self?.awayFormation = awayFormation
                self?.homeFormations = homeFormations
                self?.awayFormations = awayFormations
                self?.homeLineups = homeLineups
                self?.awayLineups = awayLineups
                //self?.homeSubstitutes = homeSubstitutes
                //self?.awaySubstitutes = awaySubstitutes
                self?.homeDirector = homeDirector
                self?.awayDirector = awayDirector
            })
            .store(in: &cancellables)
    }
    
    /// 각 팀 포메이션 변환 함수(DTO -> Entity)
    private func formationToEntity(_ dto: String) -> [Int] {
        return dto
            .split(separator: "-")
            .compactMap { Int($0) }
    }
    
    /// 각 팀 선발라인업 변환 함수(DTO -> Entity)
    private func lineupToEntity(_ dto: TeamStartingLineupResponse) -> StartingLineupModel {
        return StartingLineupModel(
            goalkeeper: SoccerPlayer(
                playerImgURL: dto.goalkeeper.playerImgURL ?? "",
                playerName: dto.goalkeeper.playerName ?? "",
                backNum: dto.goalkeeper.playerNum ?? 0
            ),
            defenders: dto.defenders.map { player in
                SoccerPlayer(
                    playerImgURL: player.playerImgURL ?? "",
                    playerName: player.playerName ?? "",
                    backNum: player.playerNum ?? 0
                )
            },
            midfielders: dto.midfielders.map { player in
                SoccerPlayer(
                    playerImgURL: player.playerImgURL ?? "",
                    playerName: player.playerName ?? "",
                    backNum: player.playerNum ?? 0
                )
            },
            midfielders2: dto.secondMidfielders?.map { player in
                SoccerPlayer(
                    playerImgURL: player.playerImgURL ?? "",
                    playerName: player.playerName ?? "",
                    backNum: player.playerNum ?? 0
                )
            } ?? [],
            strikers: dto.strikers.map { player in
                SoccerPlayer(
                    playerImgURL: player.playerImgURL ?? "",
                    playerName: player.playerName ?? "",
                    backNum: player.playerNum ?? 0
                )
            }
        )
    }
    
    /// 각 팀 후보선수 변환 함수(DTO -> Entity)
    private func substituteToEntity(_ dto: [SubstituteResponse]) -> [SubstituteModel] {
        return dto.compactMap { response in
            SubstituteModel(playerName: response.playerName, playerNum: response.playerNum)
        }
    }
    
    /// 선발라인업 선수 엔티티 변환 함수(Entity -> Entity)
    func lineupPlayerToEntity(_ entity: SoccerPlayer) -> StartingLineupPlayer {
        return StartingLineupPlayer(
            playerImgURL: entity.playerImgURL ?? "",
            playerName: entity.playerName ?? "",
            backNum: entity.backNum ?? 0,
            playerPosition: 0
        )
    }
 }
