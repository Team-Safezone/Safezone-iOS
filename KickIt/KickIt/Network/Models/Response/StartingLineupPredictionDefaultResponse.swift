//
//  StartingLineupPredictionResponse.swift
//  KickIt
//
//  Created by 이윤지 on 9/11/24.
//

import Foundation

/// 선발 라인업 예측 조회 Response 모델
struct StartingLineupPredictionDefaultResponse: Codable {
    var homeTeamPlayers: [StartingLineupPlayersResponse] // 홈팀 선수 리스트
    var awayTeamPlayers: [StartingLineupPlayersResponse] // 원정팀 선수 리스트
    var homeTeamPredictions: StartingLineupPredictionsResponse? // 사용자가 예측했던 홈팀 선발라인업 리스트
    var awayTeamPredictions: StartingLineupPredictionsResponse? // 사용자가 예측했던 원정팀 선발라인업 리스트
}

/// 선발라인업 화면에서 사용되는 선수 정보 Response 모델
struct StartingLineupPlayersResponse: Codable {
    var playerImgURL: String // 선수 이미지 URL
    var playerName: String // 선수 이름
    var playerNum: Int // 선수 등번호
    var playerPosition: Int // 선수 포지션
}
