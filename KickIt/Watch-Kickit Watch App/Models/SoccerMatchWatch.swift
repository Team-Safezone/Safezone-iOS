//
//  SoccerMatch.swift
//  Kickit-Watch Watch App
//
//  Created by DaeunLee on 9/21/24.
//

import Foundation

/// [Entity] 축구 경기 모델
struct SoccerMatchWatch: Identifiable {
    let id: Int64 // 고유 id
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

/// [Entity] 축구 팀 모델
struct SoccerTeam {
    var ranking: Int? // 랭킹
    var teamEmblemURL: String // 팀 로고 이미지
    var teamName: String // 팀 이름
}

