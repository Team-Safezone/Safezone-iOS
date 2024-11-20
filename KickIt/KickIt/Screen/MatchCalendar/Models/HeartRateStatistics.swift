//
//  HeartRateStatistics.swift
//  KickIt
//
//  Created by 이윤지 on 9/8/24.
//

import Foundation

/// [Entity] 심박수 통계 화면에서 사용하는 심박수 통계 조회 모델
struct HeartRateStatistics {
    var startDate: String  // 경기 시작 시각
    var endDate: String    // 경기 종료 시각
    var lowHeartRate: Int? // 사용자의 최저 심박수 값
    var highHeartRate: Int? // 사용자의 최고 심박수 값
    var minBPM: Int? // 최저 BPM
    var avgBPM: Int? // 평균 BPM
    var maxBPM: Int? // 최고 BPM
    var events: [HeartRateMatchEvent] // 경기 이벤트 리스트
    var homeTeamHeartRateRecords: [HeartRateRecord] // 홈팀의 심박수 기록 리스트
    var awayTeamHeartRateRecords: [HeartRateRecord] // 원정팀의 심박수 기록 리스트
    var homeTeamHeartRate: HeartRate // 홈팀의 심박수 통계
    var awayTeamHeartRate: HeartRate // 원정팀의 심박수 통계
    var homeTeamViewerPercentage: Int // 홈팀 시청자의 시청 비율
}
