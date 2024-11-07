//
//  StartingLineupPredictionRequest.swift
//  KickIt
//
//  Created by 이윤지 on 11/7/24.
//

import Foundation

/// 선발라인업 예측 Request 모델
struct StartingLineupPredictionRequest: Encodable {
    var homeFormation: Int // 홈팀 예상 포메이션
    var awayFormation: Int // 원정팀 예상 포메이션
    var homeGoalkeeper: [SoccerPlayerRequest] // 사용자가 예측한 홈팀 골기퍼 리스트
    var homeDefenders: [SoccerPlayerRequest] // 사용자가 예측한 홈팀 수비수 리스트
    var homeMidfielders: [SoccerPlayerRequest] // 사용자가 예측한 홈팀 미드필더 리스트
    var homeStrikers: [SoccerPlayerRequest] // 사용자가 예측한 홈팀 공격수 리스트
    var awayGoalkeeper: [SoccerPlayerRequest] // 사용자가 예측한 원정팀 골기퍼 리스트
    var awayDefenders: [SoccerPlayerRequest] // 사용자가 예측한 원정팀 수비수 리스트
    var awayMidfielders: [SoccerPlayerRequest] // 사용자가 예측한 원정팀 미드필더 리스트
    var awayStrikers: [SoccerPlayerRequest] // 사용자가 예측한 원정팀 공격수 리스트
}
