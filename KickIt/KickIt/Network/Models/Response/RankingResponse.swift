//
//  RankingResponse.swift
//  KickIt
//
//  Created by 이윤지 on 10/23/24.
//

import Foundation

/// 랭킹 Response 모델
struct RankingResponse: Codable {
    let ranking: Int // 순위
    let teamUrl: String // 엠블럼
    let teamName: String // 이름
    let totalMatches: Int // 총 경기 횟수
    let wins: Int // 승리 횟수
    let draws: Int // 무승부 횟수
    let losses: Int // 패배 횟수
    let points: Int // 승점
    let leagueCategory: Int? // 리그 카테고리 (0: 챔스, 1: 유로파, 2: 강등권)
}
