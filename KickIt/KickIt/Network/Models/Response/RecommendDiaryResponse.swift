//
//  RecommendDiaryResponse.swift
//  KickIt
//
//  Created by 이윤지 on 10/23/24.
//

import Foundation

/// 추천 축구 일기 리스트 Response 모델
struct RecommendDiaryResponse: Codable {
    let diaryId: Int64
    var grade: Int
    var teamUrl: String
    var teamName: String
    var nickname: String
    var diaryDate: String
    let matchDate: String
    let homeTeamName: String
    let homeTeamScore: Int
    let awayTeamName: String
    let awayTeamScore: Int
    var emotion: Int
    var highHeartRate: Int?
    var diaryContent: String
    var diaryPhotos: [String]?
    var mom: String?
    var isLiked: Bool
    var likes: Int
    var isMine: Bool
}
