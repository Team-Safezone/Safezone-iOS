//
//  MatchEventModel.swift
//  KickIt
//
//  Created by DaeunLee on 7/29/24.
//

import Foundation

// MatchEvent 모델
struct MatchEvent: Identifiable {
    let id = UUID() // 이벤트 고유 id
    let matchId: Int // 경기 고유 id
    let eventCode: Int // 0: 경기 시작, 1: 전반, 2: 휴식, 3: 후반, 4: 추가 선언, 5: 추가, 6:경기 종료
    let eventTime: String // 이벤트 발생 시각
    let eventName: String // 이벤트 명칭
    let player1: String // 정보1(골 넣은 선수,경고or 퇴장 선수, 교체 IN 선수, 홈팀 점수)
    let player2: String? // 정보2(어시스트 선수, 교체 OUT 선수, 어웨이팀 점수)
    let teamName: String? // 이벤트 발생 팀 이름
    let teamUrl: String? // 이벤트 발생 팀 url
}


struct DummyData {
    static let heartRateRecords: [HeartRateRecord] = [
        HeartRateRecord(heartRate: 75, heartRateRecordTime: 1, date: "00:05"),
        HeartRateRecord(heartRate: 80, heartRateRecordTime: 1, date: "00:15"),
        HeartRateRecord(heartRate: 85, heartRateRecordTime: 1, date: "00:30")
    ]
    
    static let heartRateMatchEvents: [HeartRateMatchEvent] = [
        HeartRateMatchEvent(teamURL: "https://example.com/team1.png", eventName: "골!", player1: "손흥민", eventTime: 7),
        HeartRateMatchEvent(teamURL: "https://example.com/team1.png", eventName: "자책골", player1: "베일", eventTime: 15),
        HeartRateMatchEvent(teamURL: "https://example.com/team2.png", eventName: "교체", player1: "케인", eventTime: 30),
        HeartRateMatchEvent(teamURL: "https://example.com/team2.png", eventName: "교체", player1: "손흥민", eventTime: 40),
        HeartRateMatchEvent(teamURL: "https://example.com/team2.png", eventName: "경고", player1: "베일", eventTime: 60),
        HeartRateMatchEvent(teamURL: "https://example.com/team2.png", eventName: "골!", player1: "케인", eventTime: 780)]
}

