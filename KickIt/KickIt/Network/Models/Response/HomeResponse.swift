//
//  HomeResponse.swift
//  KickIt
//
//  Created by 이윤지 on 9/27/24.
//

import Foundation

/// 홈 화면 조회 Response 모델
struct HomeResponse: Codable {
    let gradePoint: Int // 사용자가 획득한 총 포인트
    var matchPredictions: HomeMatchResponse? // 우승팀 예측 버튼 클릭 시 사용할 정보
    var matchDiarys: HomeDiaryResponse? // 축구 일기 쓰기 버튼 클릭 시 사용할 정보
    var favoriteImagesURL: [String] // 사용자의 관심있는 구단 이미지 URL 리스트
    var matches: [HomeMatchesResponse]? // 사용자에게 관심있을 경기 일정 리스트
}

/// 홈 화면의 우승팀 예측 버튼 클릭 시 사용할 Response 모델
struct HomeMatchResponse: Codable {
    let matchId: Int64 // 경기 id
    var matchDate: String // 축구 경기 날짜
    var matchTime: String // 축구 경기 시간
    var homeTeamName: String // 홈팀 이름
    var awayTeamName: String // 원정팀 이름
    var homeTeamEmblemURL: String // 홈팀 엠블럼 URL
    var awayTeamEmblemURL: String // 원정팀 엠블럼 URL
    
    enum CodingKeys: String, CodingKey {
        case matchId = "id"
        case matchDate, matchTime, homeTeamName, awayTeamName, homeTeamEmblemURL, awayTeamEmblemURL
    }
}

/// 축구 일기 쓰기 버튼 클릭 시 사용할 Response 모델
struct HomeDiaryResponse: Codable {
    let diaryId: Int64 // 축구 일기 id
    var matchDate: String // 축구 경기 날짜
    var matchTime: String // 축구 경기 시간
    var homeTeamName: String // 홈팀 이름
    var awayTeamName: String // 원정팀 이름
    var homeTeamEmblemURL: String // 홈팀 엠블럼 URL
    var awayTeamEmblemURL: String // 원정팀 엠블럼 URL
    
    enum CodingKeys: String, CodingKey {
        case diaryId, matchDate, matchTime, homeTeamName, awayTeamName, homeTeamEmblemURL, awayTeamEmblemURL
    }
}

/// 홈 화면의 경기 리스트 Response 모델
struct HomeMatchesResponse: Codable {
    let matchId: Int64 // 경기 id
    var matchDate: String // 축구 경기 날짜
    var matchTime: String // 축구 경기 시간
    var homeTeamName: String // 홈팀 이름
    var awayTeamName: String // 원정팀 이름
    var homeTeamEmblemURL: String // 홈팀 엠블럼 URL
    var awayTeamEmblemURL: String // 원정팀 엠블럼 URL
    var homeTeamScore: Int? // 홈팀 스코어
    var awayTeamScore: Int? // 원정팀 스코어
    var matchRound: Int // 라운드
    var matchCode: Int // 경기 상태(0: 예정, 1: 경기중, 2: 휴식, 3: 종료, 4: 연기)
    var stadium: String // 축구 경기 장소
    
    enum CodingKeys: String, CodingKey {
        case matchDate, matchTime, homeTeamName, awayTeamName, homeTeamEmblemURL, awayTeamEmblemURL, homeTeamScore, awayTeamScore, stadium
        case matchId = "id"
        case matchRound = "round"
        case matchCode = "status"
    }
}
