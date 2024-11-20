//
//  RankingModel.swift
//  KickIt
//
//  Created by 이윤지 on 10/23/24.
//

import Foundation

/// [Entity] 랭킹 리스트 모델
struct RankingModel: Identifiable {
    let id = UUID()
    var team: SoccerTeam // 팀
    let totalMatches: Int // 총 경기 횟수
    let wins: Int // 승리 횟수
    let draws: Int // 무승부 횟수
    let losses: Int // 패배 횟수
    let points: Int // 승점
    var leagueCategory: Int // 리그 카테고리 (0: 디폴트, 1: 챔스, 2: 유로파, 3: 강등권)
}
