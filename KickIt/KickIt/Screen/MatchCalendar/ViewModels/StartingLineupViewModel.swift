//
//  StartingLineupViewModel.swift
//  KickIt
//
//  Created by 이윤지 on 10/9/24.
//

import Foundation
import Combine

/// 선발라인업 조회 뷰모델
final class StartingLineupViewModel: ObservableObject {
    /// 홈팀 포메이션
    @Published var homeFormation: String = ""
    
    /// 원정팀 포메이션
    @Published var awayFormation: String = ""
    
    /// 홈팀 선발라인업
    @Published var homeLineups: StartingLineupModel?
    
    /// 원정팀 선발라인업
    @Published var awayLineups: StartingLineupModel?
    
    /// 홈팀 후보선수
    @Published var homeSubstitutes: [SoccerPlayer]?
    
    /// 원정팀 후보선수
    @Published var awaySubstitutes: [SoccerPlayer]?
    
    /// 홈팀 감독 이름
    @Published var homeDirector: String = ""
    
    /// 원정팀 감독 이름
    @Published var awayDirector: String = ""
    
    /// API 로딩 여부
    @Published var isLoading = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(matchId: Int64?) {
        if let matchId = matchId {
            self.getStartingLineup(request: MatchIdRequest(matchId: matchId))
        }
    }
    
    /// 선발라인업 조회
    private func getStartingLineup(request: MatchIdRequest) {
        isLoading = true // API 요청 시작
        MatchCalendarAPI.shared.getStartingLineup(request: request)
            .map { dto in
                let homeFormation: String = dto.homeFormation ?? ""
                let awayFormation: String = dto.awayFormation ?? ""
                
                let homeLineups: StartingLineupModel = self.lineupToEntity(dto.homeLineups ?? TeamStartingLineupResponse())
                let awayLineups: StartingLineupModel = self.lineupToEntity(dto.awayLineups ?? TeamStartingLineupResponse())
                
                let homeSubstitutes: [SoccerPlayer] = self.substituteToEntity(dto.homeSubstitutes ?? [])
                let awaySubstitutes: [SoccerPlayer] = self.substituteToEntity(dto.awaySubstitutes ?? [])
                
                let homeDirector: String = dto.homeDirector ?? ""
                let awayDirector: String = dto.awayDirector ?? ""
                
                return (homeFormation, awayFormation, homeLineups, awayLineups, homeSubstitutes, awaySubstitutes, homeDirector, awayDirector)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                case .finished:
                    self.isLoading = false // 로딩 완료
                    break
                }
            }, receiveValue: { [weak self] (homeFormation, awayFormation, homeLineups, awayLineups, homeSubstitutes, awaySubstitutes, homeDirector, awayDirector) in
                self?.homeFormation = homeFormation
                self?.awayFormation = awayFormation
                self?.homeLineups = homeLineups
                self?.awayLineups = awayLineups
                self?.homeSubstitutes = homeSubstitutes
                self?.awaySubstitutes = awaySubstitutes
                self?.homeDirector = homeDirector
                self?.awayDirector = awayDirector
                print("포메이션? \(homeFormation)")
                print("포메이션? \(self?.homeFormation ?? "00000")")
            })
            .store(in: &cancellables)
    }
    
    /// 각 팀 선발라인업 변환 함수(DTO -> Entity)
    private func lineupToEntity(_ dto: TeamStartingLineupResponse) -> StartingLineupModel {
        let goalkeeper = dto.goalkeeper?.map { player in
            SoccerPlayer(
                playerImgURL: player.playerImgURL ?? "",
                playerName: player.playerName ?? "",
                backNum: player.playerNum ?? 0
            )
        } ?? []
        let defenders = dto.defenders?.map { player in
            SoccerPlayer(
                playerImgURL: player.playerImgURL ?? "",
                playerName: player.playerName ?? "",
                backNum: player.playerNum ?? 0
            )
        } ?? []
        let midfielders = dto.midfielders?.map { player in
            SoccerPlayer(
                playerImgURL: player.playerImgURL ?? "",
                playerName: player.playerName ?? "",
                backNum: player.playerNum ?? 0
            )
        } ?? []
        let midfielders2 = dto.secondMidFielders?.map { player in
            SoccerPlayer(
                playerImgURL: player.playerImgURL ?? "",
                playerName: player.playerName ?? "",
                backNum: player.playerNum ?? 0
            )
        } ?? []
        let strikers = dto.strikers?.map { player in
            SoccerPlayer(
                playerImgURL: player.playerImgURL ?? "",
                playerName: player.playerName ?? "",
                backNum: player.playerNum ?? 0
            )
        } ?? []
        
        return StartingLineupModel(
            goalkeeper: goalkeeper,
            defenders: defenders,
            midfielders: midfielders,
            midfielders2: midfielders2,
            strikers: strikers
        )
    }
    
    /// 각 팀 후보선수 변환 함수(DTO -> Entity)
    private func substituteToEntity(_ dto: [SoccerPlayersResponse]) -> [SoccerPlayer] {
        return dto.compactMap { response in
            SoccerPlayer(
                playerImgURL: response.playerImgURL ?? "",
                playerName: response.playerName ?? "",
                backNum: response.playerNum ?? 0
            )
        }
    }
 }
