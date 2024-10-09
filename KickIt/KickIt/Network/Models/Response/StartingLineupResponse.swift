//
//  StartingLineupResponse.swift
//  KickIt
//
//  Created by 이윤지 on 10/9/24.
//

import Foundation

/// 선발라인업 조회 Response 모델
struct StartingLineupResponse: Codable {
    var homeFormation: String // 홈팀 포메이션
    var awayFormation: String // 원정팀 포메이션
    var homeLineups: TeamStartingLineupResponse // 홈팀 선발라인업 리스트
    var awayLineups: TeamStartingLineupResponse // 원정팀 선발라인업 리스트
    var homeSubstitutes: [SubstituteResponse] // 홈팀 후보선수 리스트
    var awaySubstitutes: [SubstituteResponse] // 원정팀 후보선수 리스트
    var homeDirector: String // 홈팀 감독 이름
    var awayDirector: String // 원정팀 감독 이름
}

/// 각 팀의 선발라인업 Response 모델
struct TeamStartingLineupResponse: Codable {
    var goalkeeper: SoccerPlayersResponse // 골기퍼
    var defenders: [SoccerPlayersResponse] // 수비수 리스트
    var midfielders: [SoccerPlayersResponse] // 미드필더 리스트
    var secondMidfielders: [SoccerPlayersResponse]? // 미드필더 리스트2
    var strikers: [SoccerPlayersResponse] // 공격수 리스트
}

/// 후보선수 Response 모델
struct SubstituteResponse: Codable {
    var playerName: String // 선수 이름
    var playerNum: Int // 선수 등번호
}
