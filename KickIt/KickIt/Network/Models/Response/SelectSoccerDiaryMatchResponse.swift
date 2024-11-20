//
//  SelectSoccerDiaryMatchResponse.swift
//  KickIt
//
//  Created by 이윤지 on 11/18/24.
//

import Foundation

/// 축구 일기로 기록하고 싶은 경기 선택을 위한 경기 일정 조회 Resonse 모델
struct SelectSoccerDiaryMatchResponse: Codable {
    var soccerTeamNames: [String]?
    var matches: [SelectSoccerDiaryMatchesResponse]?
    var isLeftExist: Bool
    var isRightExist: Bool
}

/// 축구 일기를 위한 경기 리스트 Resonse 모델
struct SelectSoccerDiaryMatchesResponse: Codable {
    var matchId: Int64
    var matchDate: String
    var matchTime: String
    var homeTeamEmblemURL: String
    var awayTeamEmblemURL: String
    var homeTeamName: String
    var awayTeamName: String
    var homeTeamScore: Int?
    var awayTeamScore: Int?
    
    enum CodingKeys: String, CodingKey {
        case matchId, matchDate, matchTime, homeTeamEmblemURL, homeTeamName, awayTeamName, homeTeamScore, awayTeamScore
        case awayTeamEmblemURL = "awayTeamEmblemUrl"
    }
}
