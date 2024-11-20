//
//  StartingLineupPredictionResponse.swift
//  KickIt
//
//  Created by 이윤지 on 9/11/24.
//

import Foundation

/// 선발 라인업 예측 조회 Response 모델
struct StartingLineupPredictionDefaultResponse: Codable {
    var homePlayers: [StartingLineupPlayersResponse]? // 홈팀 선수 리스트
    var awayPlayers: [StartingLineupPlayersResponse]? // 원정팀 선수 리스트
    var homePrediction: StartingLineupPredictionsResponse? // 사용자가 예측했던 홈팀 선발라인업 리스트
    var awayPrediction: StartingLineupPredictionsResponse? // 사용자가 예측했던 원정팀 선발라인업 리스트
    
    enum CodingKeys : String, CodingKey {
        case homePlayers, awayPlayers, homePrediction, awayPrediction
    }
    
//    init(homePlayers: [StartingLineupPlayersResponse] = [],
//        awayPlayers: [StartingLineupPlayersResponse] = [],
//        homePrediction: StartingLineupPredictionsResponse? = nil,
//        awayPrediction: StartingLineupPredictionsResponse? = nil) {
//            self.homePlayers = homePlayers
//            self.awayPlayers = awayPlayers
//            self.homePrediction = homePrediction
//            self.awayPrediction = awayPrediction
//    }
}

/// 선발라인업 화면에서 사용되는 선수 정보 Response 모델
struct StartingLineupPlayersResponse: Codable {
    var playerImgURL: String? // 선수 이미지 URL
    var playerName: String? // 선수 이름
    var playerNum: Int? // 선수 등번호
    var playerPos: Int? // 선수 포지션
    
    enum CodingKeys: String, CodingKey {
        case playerImgURL, playerName, playerNum, playerPos
    }
}
