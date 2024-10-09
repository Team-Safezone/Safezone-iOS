//
//  ViewerPercentageResponse.swift
//  KickIt
//
//  Created by 이윤지 on 9/3/24.
//

import Foundation

/// 심박수 통계 조회 Response 모델
struct HeartRateStatisticsResponse: Codable {
    var startDate: String  // 경기 시작 시각
    var endDate: String    // 경기 종료 시각
    var lowHeartRate: Int? // 사용자의 최저 심박수 값
    var highHeartRate: Int? // 사용자의 최고 심박수 값
    var minBPM: Int? // 최저 BPM
    var avgBPM: Int? // 평균 BPM
    var maxBPM: Int? // 최고 BPM
    var events: [HeartRateMatchEventResponse]? // 경기 이벤트 리스트
    var homeTeamHeartRateRecords: [HeartRateRecordResponse]? // 홈팀의 심박수 기록 리스트
    var awayTeamHeartRateRecords: [HeartRateRecordResponse]? // 원정팀의 심박수 기록 리스트
    var homeTeamHeartRate: HeartRateResponse? // 홈팀의 심박수 통계
    var awayTeamHeartRate: HeartRateResponse? // 원정팀의 심박수 통계
    var homeTeamViewerPercantage: Int? // 홈팀 시청자의 시청 비율
    
    enum CodingKeys: String, CodingKey {
        case startDate, endDate, lowHeartRate, highHeartRate, minBPM, avgBPM, maxBPM, events,
             homeTeamHeartRateRecords, awayTeamHeartRateRecords,
             homeTeamHeartRate, awayTeamHeartRate, homeTeamViewerPercantage
    }
}

/// 경기 이벤트 리스트 Response 모델
struct HeartRateMatchEventResponse: Codable {
    var teamURL: String // 이벤트가 발생한 팀의 엠블럼 url
    var eventName: String // 이벤트명
    var player1: String // 이벤트 주요 선수
    var eventMTime: Int // 이벤트 발생 시각
    
    enum CodingKeys: String, CodingKey {
        case teamURL, eventName, player1, eventMTime
    }
}

/// 심박수 기록 리스트 Response 모델
struct HeartRateRecordResponse: Codable {
    var heartRate: Double // 심박수
    var heartRateRecordTime: Int // 심박수 기록 시간(분)
    
    enum CodingKeys: String, CodingKey {
        case heartRate, heartRateRecordTime
    }
}

/// 심박수 통계 리스트 Response 모델
struct HeartRateResponse: Codable {
    var min: Int // 최저 심박수
    var avg: Int // 평균 심박수
    var max: Int // 최고 심박수
    
    enum CodingKeys: String, CodingKey {
        case min, avg, max
    }
}
