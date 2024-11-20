//
//  MatchEventModel.swift
//  KickIt
//
//  Created by DaeunLee on 7/29/24.
//

import Foundation

// linechartview 더미데이터
struct DummyData {
    static let homeTeamHeartRateRecords: [HeartRateRecord] = [
        HeartRateRecord(heartRate: 82, date: 0),
        HeartRateRecord(heartRate: 72, date: 15),
        HeartRateRecord(heartRate: 80, date: 30),
        HeartRateRecord(heartRate: 82, date: 45),
        HeartRateRecord(heartRate: 94, date: 60),
        HeartRateRecord(heartRate: 80, date: 75),
        HeartRateRecord(heartRate: 88, date: 90)
    ]
    
    static let awayTeamHeartRateRecords: [HeartRateRecord] = [
        HeartRateRecord(heartRate: 62, date: 0),
        HeartRateRecord(heartRate: 73, date: 15),
        HeartRateRecord(heartRate: 65, date: 30),
        HeartRateRecord(heartRate: 95, date: 45),
        HeartRateRecord(heartRate: 80, date: 60),
        HeartRateRecord(heartRate: 87, date: 75),
        HeartRateRecord(heartRate: 93, date: 90)
    ]
    
    static let heartRateMatchEvents: [HeartRateMatchEvent] = [
        HeartRateMatchEvent(teamUrl: "https://example.com/team1.png", eventName: "골!", player1: "손흥민", time: 7),
        HeartRateMatchEvent(teamUrl: "https://example.com/team1.png", eventName: "자책골", player1: "베일", time: 15),
        HeartRateMatchEvent(teamUrl: "https://example.com/team2.png", eventName: "교체", player1: "케인", time: 30),
        HeartRateMatchEvent(teamUrl: "https://example.com/team2.png", eventName: "교체", player1: "손흥민", time: 45),
        HeartRateMatchEvent(teamUrl: "https://example.com/team2.png", eventName: "경고", player1: "베일", time: 60),
        HeartRateMatchEvent(teamUrl: "https://example.com/team2.png", eventName: "골!", player1: "케인", time: 75)
    ]
}
