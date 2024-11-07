//
//  WinningTeamPredictionResponse.swift
//  KickIt
//
//  Created by 이윤지 on 11/6/24.
//

import Foundation

/// 우승팀 예측 결과 조회 Response 모델
struct WinningTeamPredictionResultResponse: Codable {
    var participant: Int
    var homeTeamScore: Int?
    var awayTeamScore: Int?
    var avgHomeTeamScore: Int?
    var avgAwayTeamScore: Int?
    var userPrediction: Bool?
    var avgPrediction: Bool?
}
