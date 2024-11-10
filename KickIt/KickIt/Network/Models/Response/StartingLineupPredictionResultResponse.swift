//
//  StartingLineupResultResponse.swift
//  KickIt
//
//  Created by 이윤지 on 11/9/24.
//

import Foundation

/// 선발라인업 예측 결과 조회 Response 모델
struct StartingLineupPredictionResultResponse {
    var participant: Int // 예측 참여자 수
    var homeFormation: Int // 실제 홈팀 포메이션
    //var homeLineups
    var goalkeeper: SoccerPlayersResponse // 사용자가 예측한 골키퍼
    var defenders: [SoccerPlayersResponse] // 사용자가 예측한 수비수 리스트
    var midfielders: [SoccerPlayersResponse] // 사용자가 예측한 미드필터 리스트
    var strikers: [SoccerPlayersResponse] // 사용자가 예측한 공격수 리스트
    var awayFormation: Int
    var userHomeFormation: Int
}
