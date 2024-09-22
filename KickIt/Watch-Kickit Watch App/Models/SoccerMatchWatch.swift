//
//  SoccerMatch.swift
//  Kickit-Watch Watch App
//
//  Created by DaeunLee on 9/21/24.
//

import Foundation

/// 서버 -> watchOS 디코딩 과정 사용 구조체
struct SoccerMatchWatch: Codable, Identifiable {
    let id: Int64
    let timeStr: String
    let homeTeam: String
    let awayTeam: String
}

struct SoccerMatchResponse: Codable {
    let message: String
    let data: [SoccerMatchWatch]
}
