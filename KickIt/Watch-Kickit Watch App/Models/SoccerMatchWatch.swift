//
//  SoccerMatch.swift
//  Kickit-Watch Watch App
//
//  Created by DaeunLee on 9/21/24.
//

import Foundation

/// API 디코딩 과정 사용 구조체
struct SoccerMatchWatch: Codable, Identifiable {
    let id: Int64
    let timeStr: String
    let homeTeam: String
    let homeTeamScore: Int?
    let awayTeam: String
    let awayTeamScore: Int?
    let status: Int // 경기 상태(0: 예정, 1: 경기중, 2: 휴식, 3: 종료, 4: 연기)
}

struct SoccerMatchResponse: Codable {
    let message: String
    let data: [SoccerMatchWatch]
}


