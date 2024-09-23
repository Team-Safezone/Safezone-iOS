//
//  StartingLineupPredictionsResponse.swift
//  KickIt
//
//  Created by 이윤지 on 9/14/24.
//

import Foundation

/// 사용자가 예측했던 선발라인업 리스트 Response 모델
struct StartingLineupPredictionsResponse: Codable {
    var formation: Int // 예상 포메이션
    var goalkeeper: SoccerPlayersResponse // 사용자가 예측한 골키퍼
    var defenders: [SoccerPlayersResponse] // 사용자가 예측한 수비수 리스트
    var midfielders: [SoccerPlayersResponse] // 사용자가 예측한 미드필터 리스트
    var strikers: [SoccerPlayersResponse] // 사용자가 예측한 공격수 리스트
}
