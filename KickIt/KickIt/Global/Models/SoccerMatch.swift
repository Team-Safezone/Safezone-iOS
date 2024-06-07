//
//  SoccerMatch.swift
//  KickIt
//
//  Created by 이윤지 on 5/11/24.
//

import Foundation

/// [Entity] 축구 경기 모델
struct SoccerMatch: Identifiable {
    let id: Int64 // 고유 id
    let soccerSeason: String // 축구 경기 시즌
    let matchDate: Date // 축구 경기 날짜
    let matchTime: Date // 축구 경기 시간
    let stadium: String // 축구 경기 장소
    let matchRound: Int // 라운드
    let homeTeam: SoccerTeam // 홈 팀
    let awayTeam: SoccerTeam // 원정 팀
    var matchCode: Int // 경기 상태(0: 예정, 1: 경기중, 2: 휴식, 3: 종료, 4: 연기)
    var homeTeamScore: Int? // 홈 팀 스코어
    var awayTeamScore: Int? // 원정 팀 스코어
}

/// 축구 경기 리스트 더미 데이터
let dummySoccerMatches: [SoccerMatch] = [
    SoccerMatch(
        id: 0,
        soccerSeason: "2023/24",
        matchDate: Calendar.current.date(from: DateComponents(year: 2024, month: 5, day: 11))!,
        matchTime: Calendar.current.date(from: DateComponents(hour: 20, minute: 30))!,
        stadium: "장소",
        matchRound: 37,
        homeTeam: SoccerTeam(id: 0, teamEmblemURL: "https://search.pstatic.net/common?type=o&size=152x114&expire=1&refresh=true&quality=95&direct=true&src=http%3A%2F%2Fsstatic.naver.net%2Fkeypage%2Fimage%2Fdss%2F146%2F33%2F80%2F97%2F146_100338097_team_image_url_1436772555621.jpg", teamName: "풀럼"),
        awayTeam: SoccerTeam(id: 0, teamEmblemURL: "https://search.pstatic.net/common?type=o&size=152x114&expire=1&refresh=true&quality=95&direct=true&src=http%3A%2F%2Fsstatic.naver.net%2Fkeypage%2Fimage%2Fdss%2F146%2F84%2F59%2F06%2F146_2845906_team_image_url_1467618027703.jpg", teamName: "맨시티"),
        matchCode: 1,
        homeTeamScore: 1,
        awayTeamScore: 0
    ),
    
    SoccerMatch(
        id: 1,
        soccerSeason: "2023/24",
        matchDate: Calendar.current.date(from: DateComponents(year: 2024, month: 5, day: 11))!,
        matchTime: Calendar.current.date(from: DateComponents(hour: 23, minute: 00))!,
        stadium: "장소",
        matchRound: 37,
        homeTeam: SoccerTeam(id: 0, teamEmblemURL: "https://search.pstatic.net/common?type=o&size=152x114&expire=1&refresh=true&quality=95&direct=true&src=http%3A%2F%2Fsstatic.naver.net%2Fkeypage%2Fimage%2Fdss%2F146%2F33%2F80%2F91%2F146_100338091_team_image_url_1436770583726.jpg", teamName: "울버햄튼"),
        awayTeam: SoccerTeam(id: 0, teamEmblemURL: "https://search.pstatic.net/common?type=o&size=152x114&expire=1&refresh=true&quality=95&direct=true&src=http%3A%2F%2Fsstatic.naver.net%2Fkeypage%2Fimage%2Fdss%2F146%2F30%2F33%2F13%2F146_100303313_team_image_url_1435211926961.png", teamName: "팰리스"),
        matchCode: 0
    ),
    
    SoccerMatch(
        id: 2,
        soccerSeason: "2023/24",
        matchDate: Calendar.current.date(from: DateComponents(year: 2024, month: 5, day: 11))!,
        matchTime: Calendar.current.date(from: DateComponents(hour: 23, minute: 00))!,
        stadium: "장소",
        matchRound: 37,
        homeTeam: SoccerTeam(id: 0, teamEmblemURL: "https://search.pstatic.net/common?type=o&size=152x114&expire=1&refresh=true&quality=95&direct=true&src=http%3A%2F%2Fsstatic.naver.net%2Fkeypage%2Fimage%2Fdss%2F146%2F33%2F80%2F91%2F146_100338091_team_image_url_1436770583726.jpg", teamName: "울버햄튼"),
        awayTeam: SoccerTeam(id: 0, teamEmblemURL: "https://search.pstatic.net/common?type=o&size=152x114&expire=1&refresh=true&quality=95&direct=true&src=http%3A%2F%2Fsstatic.naver.net%2Fkeypage%2Fimage%2Fdss%2F146%2F30%2F33%2F13%2F146_100303313_team_image_url_1435211926961.png", teamName: "팰리스"),
        matchCode: 0
    )
]
