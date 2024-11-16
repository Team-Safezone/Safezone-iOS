//
//  StartingLineupResultResponse.swift
//  KickIt
//
//  Created by 이윤지 on 11/9/24.
//

import Foundation

/// 선발라인업 예측 결과 조회 Response 모델
struct StartingLineupPredictionResultResponse: Codable {
    var participant: Int // 예측 참여자 수
    var homeFormation: String? // 홈팀 포메이션
    var homeLineups: TeamStartingLineupResponse2? // 홈팀 선발라인업
    var awayFormation: String? // 원정팀 포메이션
    var awayLineups: TeamStartingLineupResponse2? // 원정팀 선발라인업
    var userHomeFormation: Int? // 사용자가 예측한 홈팀 포메이션
    var userHomePrediction: StartingLineupPredictionCommonResultResponse? // 사용자가 예측한 홈팀 선발라인업
    var userAwayFormation: Int? // 사용자가 예측한 원정팀 포메이션
    var userAwayPrediction: StartingLineupPredictionCommonResultResponse? // 사용자가 예측한 원정팀 선발라인업
    var avgHomeFormation: Int? // 평균 예측 홈팀 포메이션
    var avgHomePrediction: StartingLineupPredictionCommonResultResponse? // 평균 예측 홈팀 선발라인업
    var avgAwayFormation: Int? // 평균 예측 원정팀 포메이션
    var avgAwayPrediction: StartingLineupPredictionCommonResultResponse? // 평균 예측 원정팀 선발라인업
    var userPrediction: [Bool]? // 사용자의 예측 성공&실패 여부 [홈팀예측 성공여부, 원정팀 예측 성공 여부]
    var avgPrediction: [Bool]? // 평균 예측 성공&실패 여부 [홈팀예측 성공여부, 원정팀 예측 성공 여부]
    
    enum CodingKeys: String, CodingKey {
        case participant, homeFormation, homeLineups, awayFormation, awayLineups, userHomeFormation, userHomePrediction, userAwayFormation, userAwayPrediction, avgHomeFormation, avgHomePrediction, avgAwayFormation, avgAwayPrediction, userPrediction, avgPrediction
    }
}

/// 선발라인업 예측 결과 조회 -> 사용자/평균 예측 결과 Response 모델
struct StartingLineupPredictionCommonResultResponse: Codable {
    var goalkeeper: SoccerPlayersResponse? // 사용자가 예측한 골키퍼
    var defenders: [SoccerPlayersResponse]? // 사용자가 예측한 수비수 리스트
    var midfielders: [SoccerPlayersResponse]? // 사용자가 예측한 미드필터 리스트
    var strikers: [SoccerPlayersResponse]? // 사용자가 예측한 공격수 리스트
    
    enum CodingKeys: String, CodingKey {
        case goalkeeper, defenders, midfielders, strikers
    }
}
