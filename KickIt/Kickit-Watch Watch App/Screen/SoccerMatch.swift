//
//  SoccerMatch.swift
//  Kickit-Watch Watch App
//
//  Created by DaeunLee on 9/21/24.
//

import Foundation

/// [Entity] 축구 경기 모델
struct SoccerMatch: Identifiable {
    let id: Int64
    let matchTime: String
    let homeTeamName: String
    let awayTeamName: String
}
