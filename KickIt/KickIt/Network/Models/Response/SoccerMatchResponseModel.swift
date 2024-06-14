//
//  SoccerMatch.swift
//  KickIt
//
//  Created by 이윤지 on 6/3/24.
//

import Foundation

/// 축구 경기 Response 모델
struct SoccerMatchResponseModel: Codable {
    let id: Int64 // 경기 고유 id
    let soccerSeason: String // 축구 경기 시즌
    var matchDate: String // 축구 경기 날짜
    var matchTime: String // 축구 경기 시간
    var homeTeamName: String // 홈 팀
    var awayTeamName: String // 원정 팀
    var homeTeamScore: Int? // 홈 팀 스코어
    var awayTeamScore: Int? // 원정 팀 스코어
    let matchRound: Int // 라운드
    var matchCode: Int // 경기 상태(0: 예정, 1: 경기중, 2: 휴식, 3: 종료, 4: 연기)
    var stadium: String // 축구 경기 장소
    
    enum CodingKeys: String, CodingKey {
        case soccerSeason = "season"
        case matchDate = "dateStr"
        case matchTime = "timeStr"
        case homeTeamName = "homeTeam"
        case awayTeamName = "awayTeam"
        case matchRound = "round"
        case matchCode = "status"
        case awayTeamScore = "awayteamScore"
        case id, homeTeamScore, stadium
    }
}
